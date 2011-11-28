module FbGraph
  class Note < Node
    include Connections::Comments
    include Connections::Likes
    include Connections::Likes::Likable

    attr_accessor :from, :subject, :message, :created_time, :updated_time, :icon

    def initialize(identifier, attributes = {})
      super
      if (from = attributes[:from])
        @from = if from[:category]
          Page.new(from[:id], from)
        else
          User.new(from[:id], from)
        end
      end
      @subject = attributes[:subject]
      @message = attributes[:message]
      if attributes[:created_time]
        @created_time = Time.parse(attributes[:created_time]).utc
      end
      if attributes[:updated_time]
        @updated_time = Time.parse(attributes[:updated_time]).utc
      end
      @icon = attributes[:icon]

      # cached connection
      cache_collection attributes, :comments
    end
  end
end