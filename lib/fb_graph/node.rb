module FbGraph

  class Node

    attr_accessor :identifier, :endpoint, :access_token
    alias_method :link, :endpoint
    alias_method :link=, :endpoint=

    def ==(other)
      instance_variables.all? do |instance_variable|
        instance_variable_get(instance_variable) == other.instance_variable_get(instance_variable)
      end
    end

    def initialize(identifier, options = {})
      raise FbGraph::NotFound.new('No identifier specified') if identifier.blank?
      @identifier   = identifier
      @endpoint     = File.join(FbGraph::ROOT_URL,identifier)
      @access_token = options[:access_token]
    end

    def picture(size = nil)
      picture_endpoint = "#{self.endpoint}/picture"
      if size
        "#{picture_endpoint}?type=#{size}"
      else
        picture_endpoint
      end
    end

    protected

    def get(options = {})
      options[:access_token] ||= self.access_token
      _endpoint_ = if options[:connection]
        File.join(self.endpoint, options[:connection])
      else
        self.endpoint
      end
      _endpoint_ << "?#{options.to_query}" unless options.blank?
      response = RestClient.get(_endpoint_)
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