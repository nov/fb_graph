module FbGraph
  module Connections
    module AdCampaignGroups
      def ad_campaign_groups(options = {})
        ad_campaign_groups = self.connection :adcampaign_groups, options
        ad_campaign_groups.map! do |ad_campaign_group|
          AdCampaignGroup.new ad_campaign_group[:id], ad_campaign_group.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      def ad_campaign_group!(options = {})
        ad_campaign_group = post options.merge(:connection => :adcampaign_groups)

        ad_campaign_group_id = ad_campaign_group[:id]

        merged_attrs = options.merge(
          :access_token => options[:access_token] || self.access_token
        )

        AdCampaignGroup.new ad_campaign_group_id, merged_attrs
      end
    end
  end
end
