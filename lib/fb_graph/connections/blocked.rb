module FbGraph
  module Connections
    module Blocked
      def blocked(options = {})
        blocked = self.connection :blocked, options
        blocked.map! do |user|
          User.new(user[:id], user.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end

      def blocked?(user, options = {})
        blocked = self.connection :blocked, options.merge(:connection_scope => user.identifier)
        blocked.present?
      end

      def block!(*users)
        options = users.extract_options!
        blocked = post options.merge(
          :connection => :blocked,
          :uid => Array(users).flatten.collect(&:identifier).join(',')
        )
        blocked.delete_if do |user_id, succeeded|
          !succeeded
        end.keys.map! do |user_id|
          User.new user_id, :access_token => (options[:access_token] || self.access_token)
        end
      end

      def unblock!(user, options = {})
        delete options.merge(:connection => :blocked, :connection_scope => user.identifier)
      end
    end
  end
end