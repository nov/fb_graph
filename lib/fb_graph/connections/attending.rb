module FbGraph
  module Connections
    module Attending
      def attending(options = {})
        members = self.connection :attending, options
        members.map! do |member|
          User.new member[:id], member.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      def attending?(user, options = {})
        member = self.connection(
          :attending, options.merge(:connection_scope => user.identifier)
        ).first
        member.present?
      end

      def attend!(options = {})
        post options.merge(:connection => :attending)
      end
      alias_method :attending!, :attend!
    end
  end
end