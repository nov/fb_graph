module FbGraph
  module Connections
    module AppNotifications
      def notify!(user, options = {})
        options[:access_token] ||= access_token
        user.notification! options
      end
    end
  end
end