module FbGraph
  module Connections
    module AdCreatives
      def ad_creatives(options = {})
        ad_creatives = self.connection :adcreatives, options
        ad_creatives.map! do |ad_creative|
          AdCreative.new ad_creative[:id], ad_creative.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
    end
  end
end
