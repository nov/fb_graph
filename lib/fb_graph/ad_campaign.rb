module FbGraph
  class AdCampaign < Node
    include Connections::AdGroups

    attr_accessor :campaign_id, :account_id, :name, :start_time, :end_time, :daily_budget, :campaign_status, :lifetime_budget

    def initialize(identifier, attributes = {})
      super

      %w(campaign_id account_id name daily_budget campaign_status lifetime_budget).each do |field|
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
