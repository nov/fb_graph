module FbGraph
  class Review < Node
    include Connections::Reviews
    
    attr_accessor :from, :to, :message, :rating, :created_time

    def initialize(identifier, attributes = {})
      super
      
      @from = attributes[:from]
      @to = attributes[:to]
      @message = attributes[:message]
      @rating = attributes[:rating]

      if attributes[:created_time]
        @created_time = Time.parse(attributes[:created_time]).utc
      end
    end

  end
end