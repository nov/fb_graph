module FbGraph
  module Connections
    module Maybe
      def maybe(options = {})
        members = self.connection :maybe, options
        members.map! do |member|
          User.new member[:id], member.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      def maybe?(user, options = {})
        member = self.connection(
          :maybe, options.merge(:connection_scope => user.identifier)
        ).first
        member.present?
      end

      def maybe!(options = {})
        post options.merge(:connection => :maybe)
      end
    end
  end
end