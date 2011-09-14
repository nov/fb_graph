module FbGraph
  module Connections
    module AdGroups
      def ad_groups(options = {})
        ad_groups = self.connection(:adgroups, options)
        ad_groups.map! do |ad_group|
          AdGroup.new(ad_group[:id], ad_group.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end

      # Note: AdGroups can only be created via the AdAccount connection. Even though it makes sense, they
      # cannot be created via the AdCampaign connection
      def ad_group!(options = {})
        ad_group = post(options.merge(:connection => :adgroups))
        AdGroup.new(ad_group[:id], options.merge(ad_group).merge(
          :access_token => options[:access_token] || self.access_token,
          :ad_id => ad_group[:id].to_i,
          :adgroup_id => ad_group[:id].to_i
        ))
      end
    end
  end
end

