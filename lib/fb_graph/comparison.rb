module FbGraph
  module Comparison
    def ==(other)
      instance_variables.all? do |key|
        if key.to_s == '@raw_attributes'
          :ignore_difference!
        else
          instance_variable_get(key) == other.instance_variable_get(key)
        end
      end
    end
  end
end