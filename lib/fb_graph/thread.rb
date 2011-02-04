module FbGraph
  class Thread < Node
    include Connections::Messages
    include Connections::Participants
    include Connections::FormerParticipants
    include Connections::Senders

    attr_accessor :snippet, :message_count, :unread_count, :tags, :updated_time

    def initialize(identifier, attributes = {})
      super
      @snippet = attributes[:snippet]
      @message_count = attributes[:message_count]
      @unread_count = attributes[:unread_count]
      @tags = []
      if attributes[:tags]
        Collection.new(attributes[:tags]).each do |tag|
          @tags << if tag.is_a?(Tag)
            tag
          else
            Tag.new(tag)
          end
        end
      end
      if attributes[:updated_time]
        @updated_time = Time.parse(attributes[:updated_time]).utc
      end
    end
  end
end