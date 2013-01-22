module FbGraph
  module Connections
    module AdGroupConversionStats
      # When retrieving stats at the AdAccount level we use the 'adgroupstats' connection
      # This returns an Array of statistics
      def ad_group_conversions(options = {})
        ad_group_conversions = self.connection :adgroupconversions, options
        ad_group_conversions.map! do |ad_group_conversion_stat|
          AdGroupConversionStat.new(nil, {
            :adgroup_id => ad_group_conversion_stat[:adgroup_id], 
            :access_token => (options[:access_token] || self.access_token), 
            :values => ad_group_conversion_stat[:values]
          })  
        end
      end
    end
  end
end
