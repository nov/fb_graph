module FbGraph
  class Property
    include Comparison

    attr_accessor :name, :text, :href

    def initialize(attriutes = {})
      @name = attriutes[:name]
      @text = attriutes[:text]
      @href = attriutes[:href]
    end
  end
end