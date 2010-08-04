module FbGraph
  module Connections
    module Activities
      def activities(options = {})
        activities = FbGraph::Collection.new(get(options.merge(:connection => 'activities')))
        activities.map! do |activity|
          FbGraph::Page.new(activity.delete(:id), activity.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end
    end
  end
end