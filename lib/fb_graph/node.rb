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
      self.class.fetch(self.identifier, options)
    end

    def self.fetch(identifier, options = {})
      _fetched_ = new(identifier).send(:get, options)
      new(_fetched_.delete(:id), _fetched_)
    end

    protected

    def get(options = {})
      _endpoint_ = build_endpoint(options.merge!(:method => :get))
      handle_response RestClient.get(_endpoint_)
    rescue RestClient::Exception => e
      raise FbGraph::Exception.new(e.http_code, e.message, e.http_body)
    end

    def post(options = {})
      _endpoint_ = build_endpoint(options.merge!(:method => :post))
      handle_response RestClient.post(_endpoint_, options)
    rescue RestClient::Exception => e
      raise FbGraph::Exception.new(e.http_code, e.message, e.http_body)
    end

    private

    def build_endpoint(options = {})
      _endpoint_ = if options[:connection]
        File.join(self.endpoint, options.delete(:connection))
      else
        self.endpoint
      end
      options[:access_token] ||= self.access_token
      options.delete_if do |k, v|
        v.blank?
      end
      if options.delete(:method) == :get && options.present?
        _endpoint_ << "?#{options.to_query}"
      end
      _endpoint_
    end

    def handle_response(response)
      _response_ = JSON.parse(response.to_s).with_indifferent_access
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
  end
end