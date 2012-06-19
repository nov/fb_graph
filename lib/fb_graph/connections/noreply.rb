module FbGraph
  module Connections
    module Noreply
      def noreply(options = {})
        members = self.connection :noreply, options
        members.map! do |member|
          User.new member[:id], member.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
      alias_method :no_reply, :noreply

      def noreply?(user, options = {})
        member = self.connection(
          :noreply, options.merge(:connection_scope => user.identifier)
        ).first
        member.present?
      end
      alias_method :no_reply?, :noreply?
    end
  end
end