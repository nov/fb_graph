module FbGraph
  module Connections
    module Attending
      def attending(options = {})
        members = self.connection(:attending, options)
        members.map! do |member|
          User.new(member[:id], member.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end

      def attending!(options = {})
        post(options.merge(:connection => :attending))
      end
    end
  end
end