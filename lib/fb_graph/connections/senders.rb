module FbGraph
  module Connections
    module Senders
      def senders(options = {})
        users = self.connection :senders, options
        users.map! do |user|
          User.new user[:id], user.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
    end
  end
end