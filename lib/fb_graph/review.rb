module FbGraph
  class Review < Node
    attr_accessor :from, :to, :message, :rating, :created_time

    def initialize(identifier, attributes = {})
      super

      @from = if (from = attributes[:from])
        User.new from[:id], from
      end
      @to = if (to = attributes[:to])
        Application.new to[:id], to
      end
      @message = attributes[:message]
      @rating = attributes[:rating]

      if attributes[:created_time]
        @created_time = Time.parse(attributes[:created_time]).utc
      end
    end
  end
end