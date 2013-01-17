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

      def ad_creative!(options = {}) 
        # change symbol keys :body, :follow_redirect to string since it is used by httpclient 
        [:body, :follow_redirect].each do |filter| 
          options[filter.to_s] = options[filter]
          options.delete(filter)
        end
        ad_creative = post(options.merge(:connection => :adcreatives)) # only id is returned
        AdCreative.new(ad_creative[:id], options.merge(ad_creative).merge(
          :access_token => options[:access_token] || self.access_token
        ))
      end
    end
  end
end

