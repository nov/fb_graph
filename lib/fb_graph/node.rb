module FbGraph
  class Node
    include Comparison

    attr_accessor :identifier, :endpoint, :access_token

    def initialize(identifier, options = {})
      @identifier   = identifier
      @endpoint     = File.join(ROOT_URL, identifier.to_s)
      @access_token = options[:access_token]
    end

    def fetch(options = {})
      options[:access_token] ||= self.access_token if self.access_token
      _fetched_ = get(options)
      self.class.new(_fetched_.delete(:id), _fetched_.merge(:access_token => options[:access_token]))
    end

    def self.fetch(identifier, options = {})
      new(identifier).fetch(options)
    end

    def connection(connection, options = {})
      collection = options[:cached_collection] || Collection.new(get(options.merge(:connection => connection)))
      Connection.new(self, connection, options.merge(:collection => collection))
    end

    def destroy(options = {})
      options[:access_token] ||= self.access_token if self.access_token
      delete(options)
    end

    protected

    def get(params = {})
      _params_ = stringfy_access_token(params)
      _endpoint_ = build_endpoint(_params_.merge!(:method => :get))
      handle_response do
        RestClient.get(_endpoint_)
      end
    end

    def post(params = {})
      _params_ = stringfy_access_token(params)
      _endpoint_ = build_endpoint(_params_.merge!(:method => :post))
      handle_response do
        RestClient.post(_endpoint_, _params_)
      end
    end

    def delete(params = {})
      _params_ = stringfy_access_token(params)
      _endpoint_ = build_endpoint(_params_.merge!(:method => :delete))
      handle_response do
        # NOTE:
        # DELETE method didn't work for some reason.
        # Use POST with "method=delete" for now.
        RestClient.post(_endpoint_, _params_.merge!(:method => :delete))
      end
    end

    private

    def build_endpoint(params = {})
      _endpoint_ = File.join([self.endpoint, params.delete(:connection), params.delete(:connection_scope)].compact.collect(&:to_s))
      params.delete_if do |k, v|
        v.blank?
      end
      if params.delete(:method) == :get && params.present?
        _endpoint_ << "?#{params.to_query}"
      end
      _endpoint_
    end

    def stringfy_access_token(params)
      _params_ = params.dup
      _params_[:access_token] ||= self.access_token
      if access_token.is_a?(OAuth2::AccessToken)
        _params_[:access_token] = _params_[:access_token].token
      end
      _params_
    end

    def handle_response
      response = yield
      case response.body
      when 'true'
        true
      when 'false'
        # NOTE: When the object is not found, Graph API returns
        #  - error response (JSON) when the identifier contains alphabet (ex. graph.facebook.com/iamnotfound)
        #  - false when the identifier is only integer + underbar (ex. graph.facebook.com/1234567890, graph.facebook.com/12345_67890)
        # This is an undocumented behaviour, so facebook might chaange it without any announcement.
        # I've posted this issue on their forum, so hopefully I'll get a document about Graph API error responses.
        # ref) http://forum.developers.facebook.com/viewtopic.php?pid=228256#p228256
        raise NotFound.new('Graph API returned false, so probably it means your requested object is not found.')
      when 'null'
        nil
      else
        _response_ = JSON.parse(response.body)
        case _response_
        when Array
          _response_.map!(&:with_indifferent_access)
        when Hash
          _response_ = _response_.with_indifferent_access
          if _response_[:error]
            case _response_[:error][:type]
            when 'OAuthAccessTokenException', 'QueryParseException', 'OAuthInvalidRequestException', 'OAuthInvalidTokenException', 'OAuthException'
              raise Unauthorized.new(_response_[:error][:message])
            else
              raise BadRequest.new("#{_response_[:error][:type]} :: #{_response_[:error][:message]}")
            end
          else
            _response_
          end
        end
      end
    rescue RestClient::Exception => e
      raise Exception.new(e.http_code, e.message, e.http_body)
    end
  end
end