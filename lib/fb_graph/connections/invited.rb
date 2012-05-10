module FbGraph
  module Connections
    module Invited
      def invited(options = {})
        members = self.connection :invited, options
        members.map! do |member|
          User.new member[:id], member.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      def invited?(user, options = {})
        member = self.connection(
          :invited, options.merge(:connection_scope => user.identifier)
        ).first
        member.present? && User.new(
          member[:id],
          member.merge(
            :access_token => options[:access_token] || self.access_token
          )
        ).rsvp_status.to_sym
      end

      def invite!(*users)
        options = users.extract_options!
        options[:users] ||= Array(users).flatten.collect(&:identifier).join(',')
        post options.merge(:connection => :invited)
      end

      def uninvite!(user, options ={})
        delete options.merge(:connection => :invited, :connection_scope => user.identifier)
      end
    end
  end
end
