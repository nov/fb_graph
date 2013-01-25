module FbGraph
  module Connections
    module Subscribers
      def subscribers(options = {})
        subscribers = self.connection :subscribers, options
        subscribers.map! do |subscriber|
          User.new subscriber[:id], subscriber.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
    end
  end
end