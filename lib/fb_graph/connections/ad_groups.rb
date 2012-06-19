module FbGraph
  module Connections
    module AdGroups
      def ad_groups(options = {}, &block)
        self.map_connection :adgroups, options, AdGroup, &block
      end

      # Note: AdGroups can only be created via the AdAccount connection. Even though it makes sense, they
      # cannot be created via the AdCampaign connection
      def ad_group!(options = {}, &block)
        post options.merge(:connection => :adgroups, :_class => Hash) do |ad_group|

          adgroup_id = ad_group[:id]

          merged_attrs = options.merge(
            :access_token => options[:access_token] || self.access_token,
            :ad_id => adgroup_id.to_i,
            :adgroup_id => adgroup_id.to_i
          )

          if options[:redownload]
            merged_attrs = merged_attrs.merge(ad_group[:data][:adgroups][adgroup_id]).with_indifferent_access
          end

          response = AdGroup.new ad_group[:id], merged_attrs

          block_given? ? (yield response) : response
        end
      end
    end
  end
end

