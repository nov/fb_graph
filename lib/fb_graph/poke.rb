module FbGraph
  class Poke
    include Comparison

    attr_accessor :from, :to, :created_time

    def initialize(attributes = {})
      if from = attributes[:from]
        @from = User.new from[:id], from
      end
      if to = attributes[:to]
        @to = User.new to[:id], to
      end
      if attributes[:created_time]
        @created_time = Time.parse attributes[:created_time]
      end
    end
  end
end