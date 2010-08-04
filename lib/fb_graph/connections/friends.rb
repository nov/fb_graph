module FbGraph
  module Connections
    module Friends
      def friends(options = {})
        users = FbGraph::Collection.new(get(options.merge(:connection => 'friends')))
        users.map! do |user|
          User.new(user.delete(:id), user.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end
    end
  end
end