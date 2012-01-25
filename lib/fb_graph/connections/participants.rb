module FbGraph
  module Connections
    module Participants
      def participants(options = {})
        users = self.connection :participants, options
        users.map! do |user|
          User.new user[:id], user.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
    end
  end
end