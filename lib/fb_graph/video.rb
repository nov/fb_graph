module FbGraph
  class Video < Node
    include Connections::Comments
    include Connections::Likes

    attr_accessor :from, :message, :description, :length, :created_time, :updated_time

    def initialize(identifier, attributes = {})
      super
      if (from = attributes[:from])
        @from = if from[:category]
          Page.new(from.delete(:id), from)
        else
          User.new(from.delete(:id), from)
        end
      end
      @message     = attributes[:message]
      @description = attributes[:description]
      @length      = attributes[:length]
      if attributes[:created_time]
        @created_time = Time.parse(attributes[:created_time]).utc
      end
      if attributes[:updated_time]
        @updated_time = Time.parse(attributes[:updated_time]).utc
      end

      # cached connection
      @_comments_ = Collection.new(attributes[:comments])
    end
  end
end