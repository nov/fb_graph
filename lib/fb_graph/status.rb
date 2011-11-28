module FbGraph
  class Status < Node
    include Connections::Comments
    include Connections::Likes
    include Connections::Likes::Likable

    attr_accessor :from, :message, :updated_time

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
      if (updated_time = attributes[:updated_time])
        @updated_time = Time.parse(updated_time).utc
      end

      # cached connection
      cache_collections attributes, :comments, :likes
    end
  end
end