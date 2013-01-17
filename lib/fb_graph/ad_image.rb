module FbGraph
  class AdImage < Node
    attr_accessor :hash, :url

    def initialize(identifier, attributes = {})
      super

      %w(hash url).each do |field|
        send("#{field}=", attributes[field.to_sym])
      end
    end

    def fetch
      raise "fetch is not allowed for AdImage, please use AdAccount#ad_images with parameter hashes"
    end

    def update
      raise "update is not allowed for AdImage"
    end

    def delete
      raise "delete is not allowed for AdImage"
    end
  end
end
