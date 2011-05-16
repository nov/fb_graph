module FbGraph
  module Connections
    module Noreply
      def noreply(options = {})
        members = self.connection(:noreply, options)
        members.map! do |member|
          User.new(member[:id], member.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end
    end
  end
end