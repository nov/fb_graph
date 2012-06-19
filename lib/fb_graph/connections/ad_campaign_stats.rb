module FbGraph
  module Connections
    module AdCampaignStats
      # When retrieving stats at the AdAccount level we use the 'adcampaignstats' connection
      # This returns an Array of statistics
      def ad_campaign_stats(options = {}, &block)
        self.map_connection :adcampaignstats, options, AdCampaignStat, &block
      end

      # Note: This could also be a connection on the AdCampaign model, but it has a different connection name
      # 'stats' instead of 'adcampaignstats'
      # In addition, it returns a single JSON response that does not conform to the standard connections 
      # array structure, making it difficult to parse with the underlying fb_graph Connection object.
    end
  end
end

