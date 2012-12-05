module FbGraph
  class Cover < Photo
    attr_accessor :offset_y

    def initialize(identifier, attributes = {})
      super
      @offset_y = attributes[:offset_y]
    end
  end
end