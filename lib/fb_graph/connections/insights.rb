module FbGraph
  module Connections
    module Insights
      def insights(options = {})
        options[:access_token] ||= self.access_token
        options[:access_token] ||= get_access_token(options[:secret]) if respond_to?(:get_access_token)
        if options[:metrics].nil?: insight_link = :insights
        else 
        	insight_link = "insights/#{options[:metrics]}"
        end
        insights = self.connection(insight_link, options)
        insights.map! do |insight|
          Insight.new(insight.delete(:id), insight.merge(:access_token => options[:access_token]))
        end
      end
    end
  end
end
