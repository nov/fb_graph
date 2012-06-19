require 'tempfile'

module FbGraph
  class Node
    include Comparison

    attr_accessor :identifier, :endpoint, :access_token, :raw_attributes

    def initialize(identifier, attributes = {})
      @identifier         = identifier
      @endpoint           = File.join(ROOT_URL, identifier.to_s)
      @access_token       = attributes[:access_token]
      @raw_attributes     = attributes
      @cached_collections = {}
      @return_class       = attributes.delete(:class) || self.class
    end

    def fetch(options = {}, &block)
      options[:access_token] ||= self.access_token if self.access_token
      batch_mode = options[:batch_mode]
      _fetched_ = get(options, &block)
      unless FbGraph.batch_mode? && batch_mode != false
        _fetched_[:access_token] ||= options[:access_token]
        self.class.new(_fetched_[:id], _fetched_)
      end
    end

    def self.fetch(identifier, options = {}, &block)
      new(identifier).fetch(options, &block)
    end

    def connection(connection, options = {}, &block)
      collection_for(connection, options.merge(:_class => Hash, :_handler_present? => block_given?)) do |collection|
        connection = Connection.new(
            self,
            connection,
            options.merge(
              :collection => Collection.new(collection)
            )
          )
        if block_given?
          yield connection
        else
          connection
        end
      end
    end
    
    def map_connection(conn, options = {}, response_type = nil, &block)
      self.connection conn, options do |collection|
        response = collection.map! do |item|
          (response_type || self.class).new item[:id], item.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
        block_given? ? (yield response) : response
      end
    end
    def update(options = {}, &block)
      post options, &block
    end

    def destroy(options = {}, &block)
      delete options, &block
    end

    protected

    def before(options = {}, &block)
      return yield unless FbGraph.batch_mode?
    end

    def after(options = {}, &block)
      return yield unless FbGraph.batch_mode?
    end

    def get(params = {}, &block)
      return_class = params.delete(:_class) || @return_class
      if params.delete(:batch_mode) != false && FbGraph.batch_mode?
        FbGraph.batch_request.get build_endpoint(params), build_params(params), return_class, &block
      else
        handle_response http_client.get(build_endpoint(params), build_params(params)), &block
      end
    end

    def post(params = {}, &block)
      return_class = params.delete(:_class) || @return_class
      if params.delete(:batch_mode) != false && FbGraph.batch_mode?
        FbGraph.batch_request.post build_endpoint(params), build_params(params), return_class, &block
      else
        handle_response http_client.post(build_endpoint(params), build_params(params)), &block
      end
    end

    def delete(params = {}, &block)
      batch_mode = params.delete(:batch_mode) != false
      _endpoint_, _params_ = build_endpoint(params), build_params(params)
      _endpoint_.query_string=_params_.try(:to_query)
      return_class = params.delete(:_class) || @return_class
      if batch_mode && FbGraph.batch_mode?
        FbGraph.batch_request.delete _endpoint_, return_class, &block
      else
        handle_response http_client.delete(_endpoint_), &block
      end
    end

    def http_client
      FbGraph.http_client
    end

    private

    def collection_for(connection, options = {}, &block)
      if @cached_collections.has_key?(connection) && options.blank?
        if block_given?
          yield @cached_collections[connection]
        else
          @cached_collections[connection]
        end
      else
        get options.merge(:connection => connection), &block
      end
    end

    def cache_collections(attributes, *connections)
      if (attributes.keys - [:access_token]).present?
        connections.each do |connection|
          @cached_collections[connection] = attributes[connection]
        end
      end
    end
    alias_method :cache_collection, :cache_collections

    def build_endpoint(params = {})
      FbGraph::Endpoint.new([self.identifier, params.delete(:connection), params.delete(:connection_scope)].compact.collect(&:to_s), params)
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
        when String, Symbol, Numeric, Date, Time, Rack::OAuth2::AccessToken::Legacy
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

    def handle_response(response = nil, &block)
      response ||= yield http_client
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
        if response.body.gsub('"', '').to_i.to_s == response.body.gsub('"', '')
          # NOTE: User#app_request! returns ID as a JSON string not as a JSON object..
          response.body.gsub('"', '')
        else
          _response_ = JSON.parse(response.body)
          if _response_.kind_of? Array
            responses = []
            actions = FbGraph.batch_request.actions
            _response_.each_with_index do |r, i|
              body = JSON.parse(r['body']).with_indifferent_access
              if (200...300).include?(r['code'])
                r = if actions[i][:return_class] == Hash
                      body
                    else
                      (actions[i][:return_class] || FbGraph::Node).new(body[:id],body)
                    end
                success = true
              else
                r = FbGraph::Exception.new(r['code'],body[:error][:message])
                success = false
              end
              if actions[i][:block].present?
                block_response = actions[i][:block].call(r, success) 
                r = block_response if actions[i][:handler_present?]
              end
              responses << r
            end
            responses
          else
            _response_ = _response_.with_indifferent_access
            if (200...300).include?(response.status)
              block_given? ? block.call(_response_) : _response_
            else
              Exception.handle_httpclient_error(_response_, response.headers)
            end
          end
        end
      end
    rescue JSON::ParserError
      raise Exception.new(response.status, "Unparsable Response: #{response.body}")
    end
  end
end
