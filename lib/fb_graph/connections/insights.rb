module FbGraph
  module Connections
    module Insights
      def insights(options = {})
        options[:access_token] ||= self.access_token || get_access_token(options[:secret])
        insights = self.connection(:insights, options)
        insights.map! do |insight|
          Insight.new(insight.merge(:access_token => options[:access_token]))
        end
      end
    end
  end
end