require 'tempfile'

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
      _fetched_[:access_token] ||= options[:access_token]
      self.class.new(_fetched_[:id], _fetched_)
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
        http_client.get build_endpoint(params), build_params(params)
      end
    end

    def post(params = {})
      handle_response do
        http_client.post build_endpoint(params), build_params(params)
      end
    end

    def delete(params = {})
      _endpoint_, _params_ = build_endpoint(params), build_params(params)
      _endpoint_ = [_endpoint_, _params_.try(:to_query)].compact.join('?')
      handle_response do
        http_client.delete _endpoint_
      end
    end

    def http_client
      _http_client_ = HTTPClient.new(
        :agent_name => "FbGraph (#{VERSION})"
      )
      _http_client_.request_filter << Debugger::RequestFilter.new if FbGraph.debugging?
      _http_client_
    end

    private

    def build_endpoint(params = {})
      File.join([self.endpoint, params.delete(:connection), params.delete(:connection_scope)].compact.collect(&:to_s))
    end

    def build_params(params)
      _params_ = params.dup
      _params_[:access_token] ||= self.access_token
      _params_.delete_if do |k, v|
        v.blank? &&
        # NOTE: allow "key=false" in params (ex. for test user creation, it supports "installed=false")
        v != false
      end
      _params_.each do |key, value|
        next if value.blank?
        _params_[key] = case value
        when String, Symbol, Numeric, Rack::OAuth2::AccessToken::Legacy
          value.to_s
        when IO, Tempfile
          value
        when defined?(ActionDispatch::Http::UploadedFile) && ActionDispatch::Http::UploadedFile
          # NOTE: for Rails 3.0.6+
          # ref) http://blog.livedoor.jp/idea_and_players/archives/5184702.html
          value.tempfile
        else
          value.to_json
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
        # NOTE: User#app_request! returns ID as a JSON string not as a JSON object..
        if response.body.gsub('"', '').to_i.to_s == response.body.gsub('"', '')
          return response.body.gsub('"', '')
        end

        _response_ = JSON.parse(response.body)
        _response_ = case _response_
        when Array
          _response_.map!(&:with_indifferent_access)
        when Hash
          _response_ = _response_.with_indifferent_access
          Exception.handle_httpclient_error(_response_, response.headers) if _response_[:error]
          _response_
        end
      end
    rescue JSON::ParserError
      raise Exception.new(response.status, "Unparsable Response: #{response.body}")
    end
  end
end
