module FbGraph
  class Insight
    include FbGraph::Comparison

    attr_accessor :name, :period, :values, :description

    def initialize(attributes = {})
      @name   = attributes[:name]
      @period = attributes[:period]
      @values = attributes[:values].collect(&:with_indifferent_access)
      @description = attributes[:description]
    end
  end
end