module FbGraph

  class Node

    attr_accessor :identifier, :endpoint, :access_token
    alias_method :link, :endpoint
    alias_method :link=, :endpoint=

    def ==(other)
      instance_variables.all? do |key|
        instance_variable_get(key) == other.instance_variable_get(key)
      end
    end

    def initialize(identifier, options = {})
      raise FbGraph::NotFound.new('No identifier specified') if identifier.blank?
      @identifier   = identifier
      @endpoint     = File.join(FbGraph::ROOT_URL,identifier)
      @access_token = options[:access_token]
    end

    protected

    def get(options = {})
      _endpoint_ = build_endpoint(options)
      handle_response RestClient.get(_endpoint_)
    end

    private

    def build_endpoint(options = {})
      # setup options
      # TODO: might needed to reject unsupported params
      options[:access_token] ||= self.access_token
      _options_ = options.reject do |k, v|
        v.blank?
      end

      # setup endpoint
      _endpoint_ = if options[:connection]
        File.join(self.endpoint, options[:connection])
      else
        self.endpoint
      end
      _endpoint_ << "?#{_options_.to_query}" unless _options_.blank?
      _endpoint_
    end

    def handle_response(response)
      case response.code
      when 200
        JSON.parse(response.to_s).with_indifferent_access
      when 401
        raise FbGraph::Unauthorized.new('Access token required')
      when 404
        raise FbGraph::NotFound.new('Object not found')
      else
        raise FbGraph::Exception.new("Error with response code: #{response.code}")
      end
    end

  end

end