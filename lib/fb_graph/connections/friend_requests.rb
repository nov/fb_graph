module FbGraph
  module Connections
    module FriendRequests
      def friend_requests(options = {})
        friend_requests = self.connection :friendrequests, options
        friend_requests.map! do |friend_request|
          FriendRequest.new friend_request
        end
      end
    end
  end
end