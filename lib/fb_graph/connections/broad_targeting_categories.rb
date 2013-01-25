module FbGraph
  module Connections
    module BroadTargetingCategories
      def broad_targeting_categories(options = {})
        broad_targeting_categories = self.connection :broadtargetingcategories, options
        broad_targeting_categories.map! do |btc|
          BroadTargetingCategory.new btc[:id], btc.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
    end
  end
end
