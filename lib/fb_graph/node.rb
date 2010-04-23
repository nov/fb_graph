module FbGraph

  class Node
    class NotFound < FbGraph::Exception; end

    attr_accessor :endpoint

    def initialize(identifier)
      raise NotFound.new('No identifier specified') if identifier.blank?
      @endpoint = File.join(FbGraph::ROOT_URL, identifier)
    end

    def picture(size = nil)
      picture_endpoint = "#{self.endpoint}/picture"
      if size
        "#{picture_endpoint}?type=#{size}"
      else
        picture_endpoint
      end
    end

  end

end