module FbGraph
  class AdConnectionObject < Node
    attr_accessor :name, :url, :type, :tabs, :picture

    def initialize(identifier, attributes = {})
      super

      %w(name url type tabs picture).each do |field|
        send("#{field}=", attributes[field.to_sym])
      end
    end
  end
end
