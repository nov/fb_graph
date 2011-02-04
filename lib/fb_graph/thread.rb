module FbGraph
  class Thread < Node
    include Connections::Messages
    include Connections::Participants
    include Connections::FormerParticipants
    include Connections::Senders

    attr_accessor :subject, :snippet, :message_count, :unread_count, :tags, :updated_time

    def initialize(identifier, attributes = {})
      super
      @subject = attributes[:subject] # NOTE: Probably obsolete
      @snippet = attributes[:snippet]
      @message_count = attributes[:message_count]
      @unread_count = attributes[:unread_count].to_i
      @tags = []
      if attributes[:tags]
        Collection.new(attributes[:tags]).each do |tag|
          @tags << Tag.new(tag)
        end
      end
      if attributes[:updated_time]
        @updated_time = Time.parse(attributes[:updated_time]).utc
      end

      # cached connection
      @_messages_ = Collection.new(attributes[:messages])
      @_participants_ = Collection.new(attributes[:participants])
      @_former_participants_ = Collection.new(attributes[:former_articipants])
      @_senders_ = Collection.new(attributes[:senders])
    end
  end
end