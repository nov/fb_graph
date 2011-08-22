module FbGraph
  module Connections
    module Blocked
      def blocked(options = {})
        blocked = self.connection(:blocked, options)
        blocked.map! do |user|
          User.new(user[:id], user.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end

      def blocked?(user, options = {})
        blocked = self.connection(:blocked, options.merge(:connection_scope => fetch_identifier(user)))
        blocked.present?
      end

      def block!(*users)
        options = users.extract_options!
        user_identifiers = Array(users).collect do |user|
          fetch_identifier user
        end
        blocked = post options.merge(:connection => :blocked, :uid => user_identifiers.join(','))
        blocked.delete_if do |user_id, succeeded|
          !succeeded
        end.keys.map! do |user_id|
          User.new(user_id, :access_token => options[:access_token] || self.access_token)
        end
      end

      def unblock!(user, options = {})
        delete options.merge(:connection => :blocked, :connection_scope => fetch_identifier(user))
      end

      private

      def fetch_identifier(user)
        if user.is_a?(User)
          user.identifier
        else
          user
        end
      end
    end
  end
end