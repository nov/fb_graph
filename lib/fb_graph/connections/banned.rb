module FbGraph
  module Connections
    module Banned
      def banned(options = {})
        banned = self.connection :banned, options
        banned.map! do |user|
          User.new(user[:id], user.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end

      def banned?(user, options = {})
        banned = self.connection :banned, options.merge(:connection_scope => user.identifier)
        banned.present?
      end

      def ban!(*users)
        options = users.extract_options!
        post options.merge(
          :connection => :banned,
          :uid => Array(users).flatten.collect(&:identifier).join(',')
        )
      end

      def unban!(user, options = {})
        delete options.merge(:connection => :banned, :connection_scope => user.identifier)
      end
    end
  end
end