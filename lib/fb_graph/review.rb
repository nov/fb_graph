module FbGraph
  class Review < Node
    attr_accessor :from, :to, :message, :rating, :created_time

    def initialize(identifier, attributes = {})
      super
      @from = if attributes[:from]
        User.new(attributes[:from][:id], attributes[:from])
      end
      @to = if attributes[:to]
        Application.new(attributes[:to][:id], attributes[:to])
      end
      @message = attributes[:message]
      @rating = attributes[:rating]
      @created_time = if attributes[:created_time]
        Time.parse(attributes[:created_time]).utc
      end
    end
  end
end