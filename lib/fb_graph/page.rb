module FbGraph
  class Page < Node
    attr_accessor :name, :category

    def initialize(identifier, options = {})
      super
      @name     = options[:name]
      @category = options[:category]
    end
  end
end