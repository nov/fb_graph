module FbGraph
  class Insight < Node
    include Comparison

    attr_accessor :name, :period, :values, :description

    def initialize(identifier, attributes = {})
      super
      @name   = attributes[:name]
      @period = attributes[:period]
      @values = attributes[:values].collect(&:with_indifferent_access)
      @description = attributes[:description]
    end
  end
end