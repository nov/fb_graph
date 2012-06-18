module FbGraph
  module OpenGraph
    module UserContext
      def og_actions(action, options = {})
        actions = self.connection(action, options)
        actions.map! do |_action_|
          Action.new _action_[:id], _action_.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      def og_action!(action, options = {}, &block)
        options[:access_token] ||= self.access_token
        action = post options.merge(:connection => action, :class => Action), &block
        return if action.is_a? FbGraph::BatchRequest
        Action.new action[:id], action
      end
    end
  end
end
