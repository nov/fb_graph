module FbGraph
  module Connections
    module AdGroupStats
      # When retrieving stats at the AdAccount level we use the 'adgroupstats' connection
      # This returns an Array of statistics
      def ad_group_stats(options = {})
        ad_group_stats = self.connection :adgroupstats, options
        ad_group_stats.map! do |ad_group_stat|
          AdGroupStat.new ad_group_stat[:id], ad_group_stat.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      # Note: This could also be a connection on the AdGroup model, but it has a different connection name
      # 'stats' instead of 'adgroupstats'
      # In addition, it returns a single JSON response that does not conform to the standard connections 
      # array structure, making it difficult to parse with the underlying fb_graph Connection object.
    end
  end
end

