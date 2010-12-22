module FbGraph
  class Status < Node
    include Connections::Comments
    include Connections::Likes

    attr_accessor :from, :message, :updated_time

    def initialize(identifier, attributes = {})
      super
      if (from = attributes[:from])
        @from = if from[:category]
          FbGraph::Page.new(from.delete(:id), from)
        else
          FbGraph::User.new(from.delete(:id), from)
        end
      end
      @message = attributes[:message]
      if (updated_time = attributes.delete(:updated_time))
        @updated_time = Time.parse(updated_time).utc
      end

      # cached connection
      @_comments_ = FbGraph::Collection.new(attributes[:comments])
      @_likes_ = FbGraph::Collection.new(attributes[:likes])
    end
  end
end