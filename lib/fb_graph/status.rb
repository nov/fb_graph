module FbGraph
  class Status < Node
    include Connections::Comments
    include Connections::Likes

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
      @_comments_ = Collection.new(attributes[:comments])
      @_likes_ = Collection.new(attributes[:likes])
    end
  end
end