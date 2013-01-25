module FbGraph
  class AdCampaignStat < Node
    attr_accessor :start_time, :end_time, :campaign_id, :impressions, :clicks, :spent, :social_impressions, :social_clicks, :social_spent,
      :actions, :unique_impressions, :social_unique_impressions, :unique_clicks, :social_unique_clicks, :connections

    def initialize(identifier, attributes = {})
      super

      %w(campaign_id impressions clicks spent social_impressions social_clicks social_spent actions unique_impressions social_unique_impressions unique_clicks social_unique_clicks connections).each do |field|
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
  end
end
