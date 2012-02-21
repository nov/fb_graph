module FbGraph
  class AdGroup < Node
    attr_accessor :ad_id, :campaign_id, :name, :adgroup_status, :bid_type, :max_bid, :targeting, :creative, :creative_ids, :adgroup_id,
      :end_time, :start_time, :updated_time, :bid_info, :disapprove_reason_descriptions

    def initialize(identifier, attributes = {})
      super
      set_attrs(attributes)
    end

    # We override update to handle the "redownload" parameter
    # If redownload is specified, the FbGraph::AdGroup object will be updated with the data returned from Facebook.
    def update(options)
      response = super(options)

      if [1, "1", true].include?(options.symbolize_keys[:redownload])
        attributes = options.merge(response[:data][:adgroups][identifier].symbolize_keys)
        set_attrs(attributes)
      end

      response
    end

    protected

    def set_attrs(attributes)
      %w(ad_id campaign_id name adgroup_status bid_type max_bid targeting creative creative_ids adgroup_id bid_info disapprove_reason_descriptions).each do |field|
        send("#{field}=", attributes[field.to_sym])
      end

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

