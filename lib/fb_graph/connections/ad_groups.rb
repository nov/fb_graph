module FbGraph
  module Connections
    module AdGroups
      def ad_groups(options = {})
        ad_groups = self.connection :adgroups, options
        ad_groups.map! do |ad_group|
          AdGroup.new ad_group[:id], ad_group.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      # Note: AdGroups can only be created via the AdAccount connection. Even though it makes sense, they
      # cannot be created via the AdCampaign connection
      def ad_group!(options = {})
        ad_group = post options.merge(:connection => :adgroups)

        adgroup_id = ad_group[:id]

        merged_attrs = options.merge(
          :access_token => options[:access_token] || self.access_token,
          :ad_id => adgroup_id.to_i,
          :adgroup_id => adgroup_id.to_i
        )

        if options[:redownload]
          merged_attrs = merged_attrs.merge(ad_group[:data][:adgroups][adgroup_id]).with_indifferent_access
        end

        AdGroup.new ad_group[:id], merged_attrs
      end
    end
  end
end

