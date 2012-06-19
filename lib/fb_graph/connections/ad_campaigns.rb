module FbGraph
  module Connections
    module AdCampaigns
      def ad_campaigns(options = {}, &block)
        ad_campaigns = self.map_connection :adcampaigns, options, AdCampaign, &block
      end

      def ad_campaign!(options = {}, &block)
        post options.merge(:connection => :adcampaigns, :__class__ => Hash) do |ad_campaign|

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
end
