module FbGraph
  class Page < Node
    include Connections::Picture
    include Connections::Statuses

    attr_accessor :name, :category

    def initialize(identifier, options = {})
      super
      @name     = options[:name]
      @category = options[:category]
    end
  end
end