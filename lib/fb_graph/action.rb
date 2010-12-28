module FbGraph
  class Action
    include Comparison

    attr_accessor :name, :link

    def initialize(attriutes = {})
      @name = attriutes[:name]
      @link = attriutes[:link]
    end
  end
end