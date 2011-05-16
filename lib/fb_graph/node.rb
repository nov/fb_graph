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
      self.class.new(_fetched_[:id], _fetched_.merge(:access_token => options[:access_token]))
    end

    def self.fetch(identifier, options = {})
      new(identifier).fetch(options)
    end

    def connection(connection, options = {})
      collection = options[:cached_collection] || Collection.new(get(options.merge(:connection => connection)))
      Connection.new(self, connection, options.merge(:collection => collection))
    end

    def update(options = {})
      post(options)
    end

    def destroy(options = {})
      delete(options)
    end

    protected

    def get(params = {})
      handle_response do
        HTTPClient.new.get build_endpoint(params), build_params(params)
      end
    end

    def post(params = {})
      handle_response do
        HTTPClient.new.post build_endpoint(params), build_params(params)
      end
    end

    def delete(params = {})
      _endpoint_, _params_ = build_endpoint(params), build_params(params)
      _endpoint_ = [_endpoint_, _params_.try(:to_query)].compact.join('?')
      handle_response do
        HTTPClient.new.delete _endpoint_
      end
    end

    private

    def build_endpoint(params = {})
      File.join([self.endpoint, params.delete(:connection), params.delete(:connection_scope)].compact.collect(&:to_s))
    end

    def build_params(params)
      _params_ = params.dup
      _params_[:oauth_token] = (_params_.delete(:access_token) || self.access_token).to_s
      _params_.delete_if do |k, v|
        v.blank?
      end
      _params_.each do |key, value|
        if value.present? && ![Symbol, String, Numeric, IO].any? { |klass| value.is_a? klass }
          _params_[key] = value.to_json
        elsif [Symbol, Numeric].any? { |klass| value.is_a? klass }
          _params_[key] = value.to_s
        end
      end
      _params_.blank? ? nil : _params_
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
        _response_ = case _response_
        when Array
          _response_.map!(&:with_indifferent_access)
        when Hash
          _response_ = _response_.with_indifferent_access
          handle_httpclient_error(_response_) if _response_[:error]
          _response_
        end
      end
    rescue JSON::ParserError
      raise Exception.new(response.status, 'Unparsable Error Response')
    end

    def handle_httpclient_error(response)
      case response[:error][:type]
      when /OAuth/
        raise Unauthorized.new("#{response[:error][:type]} :: #{response[:error][:message]}")
      else
        raise BadRequest.new("#{response[:error][:type]} :: #{response[:error][:message]}")
      end
    end
  end
end