module FbGraph
  class Insight
    include FbGraph::Comparison

    attr_accessor :name, :period, :values

    def initialize(attributes = {})
      @name   = attributes[:name]
      @period = attributes[:period]
      @values = attributes[:values].collect(&:with_indifferent_access)
    end
  end
end