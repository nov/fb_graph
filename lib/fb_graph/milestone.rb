module FbGraph
  class Milestone < Node
    attr_accessor :from, :title, :description, :created_time, :updated_time, :start_time, :end_time

    def initialize(identifier, attributes = {})
      super
      if (from = attributes[:from])
        @from = Page.new from[:id], from
      end
      [:title, :description].each do |key|
        self.send :"#{key}=", attributes[key]
      end
      [:created_time, :updated_time, :start_time, :end_time].each do |key|
        if (value = attributes[key])
          time = case value
          when String
            Time.parse(value)
          else
            value
          end
          self.send :"#{key}=", time
        end
      end
    end
  end
end