module FbGraph
  class AdGroup < Node
    attr_accessor :ad_id, :campaign_id, :name, :adgroup_status, :bid_type, :max_bid, :targeting, :creative, :creative_ids, :adgroup_id,
      :end_time, :start_time, :updated_time, :bid_info, :disapprove_reason_descriptions

    def initialize(identifier, attributes = {})
      super

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

