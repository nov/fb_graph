module FbGraph
  module Connections
    module Insights
      def insights(options = {})
        options[:access_token] ||= self.access_token
        options[:access_token] ||= get_access_token(options[:secret]) if respond_to?(:get_access_token)
        insights = self.connection(:insights, options.merge(:connection_scope => connection_scope(options)))
        insights.map! do |insight|
          Insight.new(insight.delete(:id), insight.merge(:access_token => options[:access_token]))
        end
      end

      private

      def connection_scope(options)
        if metrics = options.delete(:metrics)
          File.join([metrics, options.delete(:period)].compact)
        else
          nil
        end
      end
    end
  end
end