module FbGraph
  class AdGroup < Node
    include Connections::AdCreatives
    include Connections::ReachEstimates

    attr_accessor :ad_id, :campaign_id, :name, :adgroup_status, :bid_type, :max_bid, :targeting, :creative, :creative_ids, :adgroup_id,
      :end_time, :start_time, :updated_time, :bid_info, :disapprove_reason_descriptions, :view_tags

    def initialize(identifier, attributes = {})
      super
      set_attrs(attributes)
    end

    # We override update to handle the "redownload" parameter
    # If redownload is specified, the FbGraph::AdGroup object will be updated with the data returned from Facebook.
    def update(options)
      response = super(options)

      if options[:redownload]
        attributes = options.merge(response[:data][:adgroups][identifier]).with_indifferent_access
        set_attrs(attributes)
      end

      response
    end

    def creatives(fetch = true)
      creative_ids.map { |creative_id| fetch ? AdCreative.fetch(creative_id) : AdCreative.new(creative_id) }
    end

    protected

    def set_attrs(attributes)
      %w(ad_id campaign_id name adgroup_status bid_type max_bid targeting creative creative_ids adgroup_id bid_info disapprove_reason_descriptions view_tags).each do |field|
        send("#{field}=", attributes[field.to_sym])
      end

      # max_bid is string only when reloaded for some reason..
      self.max_bid = max_bid.try(:to_i)

      %w(start_time end_time updated_time).each do |field|
        if val = attributes[field.to_sym]
          # Handles integer timestamps and ISO8601 strings
          time = Time.parse(val) rescue Time.at(val.to_i)
          send("#{field}=", time)
        end
      end
    end
  end
end

