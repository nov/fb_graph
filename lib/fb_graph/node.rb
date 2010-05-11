module FbGraph
  class Node
    include FbGraph::Comparison

    attr_accessor :identifier, :endpoint, :access_token

    def initialize(identifier, options = {})
      @identifier   = identifier
      @endpoint     = File.join(FbGraph::ROOT_URL, identifier.to_s)
      @access_token = options[:access_token]
    end

    def fetch(options = {})
      options[:access_token] ||= self.access_token if self.access_token
      _fetched_ = get(options)
      self.class.new(_fetched_.delete(:id), _fetched_)
    end

    def self.fetch(identifier, options = {})
      new(identifier).fetch(options)
    end

    def destroy(options = {})
      options[:access_token] ||= self.access_token if self.access_token
      destory(self.identifier, options)
    end

    protected

    def get(params = {})
      _endpoint_ = build_endpoint(params.merge!(:method => :get))
      handle_response do
        RestClient.get(_endpoint_)
      end
    end

    def post(params = {})
      _endpoint_ = build_endpoint(params.merge!(:method => :post))
      handle_response do
        RestClient.post(_endpoint_, params)
      end
    end

    def delete(params = {})
      _endpoint_ = build_endpoint(params.merge!(:method => :delete))
      handle_response do
        RestClient.delete(_endpoint_, params)
      end
    end

    private

    def build_endpoint(params = {})
      _endpoint_ = if params[:connection]
        File.join(self.endpoint, params.delete(:connection))
      else
        self.endpoint
      end
      params[:access_token] ||= self.access_token
      params.delete_if do |k, v|
        v.blank?
      end
      if params.delete(:method) == :get && params.present?
        _endpoint_ << "?#{params.to_query}"
      end
      _endpoint_
    end

    def handle_response
      response = yield
      case response.body
      when 'true'
        true
      else
        _response_ = JSON.parse(response.body).with_indifferent_access
        if _response_[:error]
          case _response_[:error][:type]
          when 'OAuthAccessTokenException'
            raise FbGraph::Unauthorized.new(401, _response_[:error][:message])
          when 'QueryParseException'
            raise FbGraph::NotFound.new(404, _response_[:error][:message])
          else
            raise FbGraph::Exception.new(400, "#{_response_[:error][:type]} :: #{_response_[:error][:message]}")
          end
        else
          _response_
        end
      end
    rescue RestClient::Exception => e
      raise FbGraph::Exception.new(e.http_code, e.message, e.http_body)
    end
  end
end