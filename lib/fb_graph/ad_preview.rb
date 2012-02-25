module FbGraph
  class AdPreview < Node
    attr_accessor :preview_data

    def initialize(attributes = {})
      super
      self.preview_data = Collection.new(attributes).first
    end
  end
end
