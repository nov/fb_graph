module FbGraph
  class AdPreview < Node
    attr_accessor :preview_data

    def initialize(attributes = {})
      super
      self.preview_data = attributes["0"]
    end
  end
end
