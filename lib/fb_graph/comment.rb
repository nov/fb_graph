module FbGraph
  class Comment < Node
    include Connections::Likes

    attr_accessor :from, :message, :created_time, :like_count

    def initialize(identifier, attributes = {})
      super
      if (from = attributes[:from])
        @from = if from[:category]
          Page.new(from[:id], from)
        else
          User.new(from[:id], from)
        end
      end
      @message = attributes[:message]
      @like_count = attributes[:likes]
      if attributes[:created_time]
        @created_time = Time.parse(attributes[:created_time]).utc
      end
    end
  end
end