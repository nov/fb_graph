module FbGraph
  class Action
    include Comparison

    attr_accessor :name, :link

    def initialize(attributes = {})
      @name = attributes[:name]
      @link = attributes[:link]
    end
  end
end