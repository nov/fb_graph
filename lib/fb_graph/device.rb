module FbGraph
  class Device
    include Comparison
    attr_accessor :os, :hardware

    def initialize(attributes = {})
      @os = attributes[:os]
      @hardware = attributes[:hardware]
    end
  end
end