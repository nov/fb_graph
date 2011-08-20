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

      def blocked?()
        
      end

      def block!()
        
      end

      def unblock!()
        
      end
    end
  end
end