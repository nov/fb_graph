module FbGraph
  module Connections
    module Interests
      def interests(options = {})
        interests = self.connection :interests, options
        interests.map! do |interest|
          Page.new interest[:id], interest.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
    end
  end
end