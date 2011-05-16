module FbGraph
  module Connections
    module Messages
      def messages(options = {})
        messages = if @_messages_ && options.blank?
          self.connection(:messages, options.merge(:cached_collection => @_messages_))
        else
          self.connection(:messages, options)
        end
        messages.map! do |message|
          Message.new(message[:id], message.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end
    end
  end
end