module FbGraph
  module OpenGraph
    module UserContext
      def og_action!(action, options = {})
        action = post options.merge(:connection => action)
        OpenGraph::Action.new action[:id], action.merge(
          :access_token => options[:access_token] || self.access_token
        )
      end
    end
  end
end