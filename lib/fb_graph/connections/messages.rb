module FbGraph
  module Connections
    module Messages
      def messages(options = {})
        messages = self.connection :messages, options
        messages.map! do |message|
          Message.new message[:id], message.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      def message!(message, options = {})
        options[:message] = message
        message = post options.merge(:connection => :messages)
        Message.new message[:id], message.merge(options).merge(
          :access_token => options[:access_token] || self.access_token
        )
      end
    end
  end
end