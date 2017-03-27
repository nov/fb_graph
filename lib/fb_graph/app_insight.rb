module FbGraph
  class AppInsight
    include Comparison

    attr_accessor :time, :value

    def initialize(attributes = {})
      @time  = Time.parse(attributes[:time]).utc
      @value = attributes[:value].to_i
    end
  end
end
