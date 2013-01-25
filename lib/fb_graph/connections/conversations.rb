module FbGraph
  module Connections
    module Conversations
      def conversations(options = {})
        conversations = self.connection :conversations, options
        conversations.map! do |conversation|
          Thread.new conversation[:id], conversation.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
    end
  end
end