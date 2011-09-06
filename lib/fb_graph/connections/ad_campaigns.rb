module FbGraph
  module Connections
    module AdCampaigns
      def ad_campaigns(options = {})
        ad_campaigns = self.connection(:adcampaigns, options)
        ad_campaigns.map! do |ad_campaign|
          AdCampaign.new(ad_campaign[:id], ad_campaign.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end

      def ad_campaign!(options = {})
        ad_campaign = post(options.merge(:connection => :adcampaigns))
        AdCampaign.new(ad_campaign[:id], options.merge(ad_campaign).merge(
          :access_token => options[:access_token] || self.access_token
        ))
      end
    end
  end
end
