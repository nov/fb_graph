module FbGraph
  module Connections
    module MutualFriends
      def mutual_friends(friend, options = {})
        friends = self.connection :mutualfriends, options.merge(
          :connection_scope => connection_scope(friend)
        )
        friends.map! do |friend|
          User.new friend[:id], friend.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      private

      def connection_scope(friend)
        if friend.is_a?(User)
          friend.identifier
        else
          friend
        end
      end
    end
  end
end