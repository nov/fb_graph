module FbGraph
  module Connections
    module AppInsights
      def app_insights(metric_key, options = {})
        options[:access_token] ||= self.access_token
        app_insights = self.connection :app_insights, options.merge(metric_key: metric_key)
        app_insights.map! do |app_insight|
          AppInsight.new app_insight
        end
      end
    end
  end
end
