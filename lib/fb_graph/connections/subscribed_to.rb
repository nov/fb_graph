module FbGraph
  module Connections
    module SubscribedTo
      def subscribed_to(options = {})
        subscribees = self.connection :subscribedto, options
        subscribees.map! do |subscribee|
          User.new subscribee[:id], subscribee.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
    end
  end
end