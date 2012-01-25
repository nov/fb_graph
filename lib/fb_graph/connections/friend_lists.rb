module FbGraph
  module Connections
    module FriendLists
      def friend_lists(options = {})
        friend_lists = self.connection :friendlists, options
        friend_lists.map! do |friend_list|
          FriendList.new friend_list[:id], friend_list.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      def friend_list!(options = {})
        friend_list = post options.merge(:connection => :friendlists)
        FriendList.new friend_list[:id], options.merge(friend_list).merge(
          :access_token => options[:access_token] || self.access_token
        )
      end
    end
  end
end