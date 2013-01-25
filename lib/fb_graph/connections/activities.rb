module FbGraph
  module Connections
    module Activities
      def activities(options = {})
        activities = self.connection :activities, options
        activities.map! do |activity|
          Page.new activity[:id], activity.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
    end
  end
end