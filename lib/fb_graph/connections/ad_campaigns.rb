module FbGraph
  module Connections
    module AdCampaigns
      def ad_campaigns(options = {})
        ad_campaigns = self.connection :adcampaigns, options
        ad_campaigns.map! do |ad_campaign|
          AdCampaign.new ad_campaign[:id], ad_campaign.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      def ad_campaign!(options = {})
        ad_campaign = post options.merge(:connection => :adcampaigns)

        ad_campaign_id = ad_campaign[:id]

        merged_attrs = options.merge(
          :access_token => options[:access_token] || self.access_token
        )

        if options[:redownload]
          merged_attrs = merged_attrs.merge(ad_campaign[:data][:campaigns][ad_campaign_id]).with_indifferent_access
        end

        AdCampaign.new ad_campaign_id, merged_attrs
      end
    end
  end
end
