module FbGraph
  module Connections
    module Members
      def members(options = {})
        members = self.connection(:members, options)
        members.map! do |member|
          User.new(member[:id], member.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end
    end
  end
end