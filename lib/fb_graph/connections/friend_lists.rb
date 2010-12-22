module FbGraph
  module Connections
    module FriendLists
      def friend_lists(options = {})
        friend_lists = self.connection(:friendlists, options)
        friend_lists.map! do |friend_list|
          FriendList.new(friend_list.delete(:id), friend_list.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end
    end
  end
end