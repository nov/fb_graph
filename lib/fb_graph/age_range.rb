module FbGraph
  class AgeRange < Range
    DEFAULT_MAX_AGE = 9999

    def initialize(attributes = {})
      super attributes[:min], attributes[:max] || DEFAULT_MAX_AGE
    end

    alias_method :min, :first
    alias_method :max, :last
  end
end