module FbGraph
  class AdGroupStat < Node
    ATTRS = [:start_time, :end_time, :adgroup_id, :campaign_id, :impressions, :clicks, :spent, 
      :social_impressions, :social_clicks, :social_spent, :actions, :unique_impressions,
      :social_unique_impressions, :unique_clicks, :social_unique_clicks, :connections, :newsfeed_position]

    attr_accessor *ATTRS

    def initialize(identifier, attributes = {})
      super

      ATTRS.each do |field|
        send("#{field}=", attributes[field.to_sym])
      end

      %w(start_time end_time).each do |field|
        if val = attributes[field.to_sym]
          # Handles integer timestamps and ISO8601 strings
          time = Time.parse(val) rescue Time.at(val.to_i)
          send("#{field}=", time)
        end
      end
    end

    def update(options={})
      raise "Not allowed to update an AdGroupStat"
    end

    def destroy(options={})
      raise "Not allowed to delete an AdGroupStat"
    end

  end
end
