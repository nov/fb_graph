module FbGraph
  module Connections
    module Maybe
      def maybe(options = {})
        members = self.connection(:maybe, options)
        members.map! do |member|
          User.new(member[:id], member.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end

      def maybe!(options = {})
        post(options.merge(:connection => :maybe))
      end
    end
  end
end