module FbGraph
  module Connections
    module Activities
      def activities(options = {})
        activities = Collection.new(get(options.merge(:connection => 'activities')))
        activities.map! do |activity|
          Page.new(activity.delete(:id), activity)
        end
      end
    end
  end
end