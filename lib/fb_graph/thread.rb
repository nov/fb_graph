module FbGraph
  class Thread < Node
    include Connections::Messages
    include Connections::Participants
    include Connections::FormerParticipants
    include Connections::Senders
    include Connections::Tags

    attr_accessor :subject, :snippet, :message_count, :unread_count, :updated_time

    def initialize(identifier, attributes = {})
      super
      @subject = attributes[:subject] # NOTE: New Facebook Message platform will make this field blank.
      @snippet = attributes[:snippet]
      @message_count = attributes[:message_count]
      @unread_count = attributes[:unread_count].to_i
      if attributes[:updated_time]
        @updated_time = Time.parse(attributes[:updated_time]).utc
      end

      # cached connection
      @_messages_ = Collection.new(attributes[:messages])
      @_participants_ = Collection.new(attributes[:participants])
      @_former_participants_ = Collection.new(attributes[:former_articipants])
      @_senders_ = Collection.new(attributes[:senders])
      @_tags_ = Collection.new(attributes[:tags])
    end
  end
end