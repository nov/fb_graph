module FbGraph
  module Connections
    module Family
      def family(options = {})
        users = self.connection :family, options
        users.map! do |user|
          User.new user[:id], user.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
    end
  end
end