module FbGraph
  class Image
    include Comparison
    attr_accessor :source, :height, :width
    def initialize(attributes = {})
      @source = attributes[:source]
      @height = attributes[:height]
      @width  = attributes[:width]
    end
  end
end