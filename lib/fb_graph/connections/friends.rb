module FbGraph
  module Connections
    module Friends
      def friends(options = {})
        users = self.connection :friends, options
        users.map! do |user|
          User.new user[:id], user.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
    end
  end
end