module FbGraph
  class Property
    include Comparison

    attr_accessor :name, :text, :href

    def initialize(attributes = {})
      @name = attributes[:name]
      @text = attributes[:text]
      @href = attributes[:href]
    end
  end
end