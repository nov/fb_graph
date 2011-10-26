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

      def og_action!(action, options = {})
        action = post options.merge(:connection => action)
        Action.new action[:id], action.merge(
          :access_token => options[:access_token] || self.access_token
        )
      end
    end
  end
end