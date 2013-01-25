module FbGraph
  module Connections
    module Members
      def members(options = {})
        members = self.connection :members, options
        members.map! do |member|
          User.new member[:id], member.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      def member!(user, options = {})
        post options.merge(:connection => :members, :connection_scope => user.identifier)
      end

      def unmember!(user, options = {})
        delete options.merge(:connection => :members, :connection_scope => user.identifier)
      end
    end
  end
end