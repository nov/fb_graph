module FbGraph
  module Connections
    module Invited
      def invited(options = {})
        members = self.connection(:invited, options)
        members.map! do |member|
          User.new(member[:id], member.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end
    end
  end
end