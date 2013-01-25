module FbGraph
  class Thread < Node
    include Connections::Messages
    include Connections::Participants
    include Connections::FormerParticipants
    include Connections::Senders
    include Connections::Tags

    attr_accessor :snippet, :message_count, :unread_count, :updated_time

    def initialize(identifier, attributes = {})
      super
      @snippet = attributes[:snippet]
      @message_count = attributes[:message_count]
      @unread_count = attributes[:unread_count].to_i
      if attributes[:updated_time]
        @updated_time = Time.parse(attributes[:updated_time]).utc
      end

      # cached connection
      cache_collections attributes, :messages, :participants, :former_participants, :senders, :tags
    end

    # NOTE:
    #  Facebook is under transision of their message platform.
    #  This is current thread model in Graph API.
    #  In near future, this will be replaced with FbGraph::Thread model.
    class BeforeTransition < Node
      attr_accessor :subject, :message, :from, :to, :unread, :unseen, :updated_time

      def initialize(identifier, attributes = {})
        super
        @subject = attributes[:subject]
        @message = attributes[:message]
        if (from = attributes[:from])
          @from = if from[:start_time]
            Event.new(from[:id], from)
          else
            User.new(from[:id], from)
          end
        end
        @to = []
        Collection.new(attributes[:to]).each do |to|
          @to << User.new(to[:id], to)
        end
        if attributes[:updated_time]
          @created_time = Time.parse(attributes[:updated_time]).utc
        end
        @unread = attributes[:unread] == 1
        @unseen = attributes[:unseen] == 1

        # cached connection
        cache_collection attributes, :comments
      end

      # NOTE:
      #  This is a connection named "comments" but returns "messages" and different from normal "comments" connection.
      #  Therefore I put this connection here not under FbGraph::Connections.
      def messages(options = {})
        messages = self.connection(:comments, options)
        messages.map! do |message|
          Message.new(message[:id], message.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end
      # for pagination, a method which name is same as the connection name is needed.
      alias_method :comments, :messages
    end
  end
end