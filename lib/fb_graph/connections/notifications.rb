module FbGraph
  module Connections
    module Notifications
      def notifications(options = {})
        notifications = self.connection :notifications, options
        notifications.map! do |notification|
          Notification.new notification[:id], notification.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      def notification!(options = {})
        post options.merge(:connection => :notifications)
      end
    end
  end
end