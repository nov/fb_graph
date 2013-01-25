module FbGraph
  module Connections
    module AdCampaignStats
      # When retrieving stats at the AdAccount level we use the 'adcampaignstats' connection
      # This returns an Array of statistics
      def ad_campaign_stats(options = {})
        ad_campaign_stats = self.connection :adcampaignstats, options
        ad_campaign_stats.map! do |ad_campaign_stat|
          AdCampaignStat.new ad_campaign_stat[:id], ad_campaign_stat.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      # Note: This could also be a connection on the AdCampaign model, but it has a different connection name
      # 'stats' instead of 'adcampaignstats'
      # In addition, it returns a single JSON response that does not conform to the standard connections 
      # array structure, making it difficult to parse with the underlying fb_graph Connection object.
    end
  end
end

