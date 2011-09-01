module FbGraph
  class AdCampaign < Node
    attr_accessor :campaign_id, :account_id, :name, :start_time, :end_time, :daily_budget, :campaign_status, :lifetime_budget

    def initialize(identifier, attributes = {})
      super

      %w(campaign_id account_id name daily_budget campaign_status lifetime_budget).each do |field|
        send("#{field}=", attributes[field.to_sym])
      end

      %w(start_time end_time).each do |field|
        send("#{field}=", Time.parse(attributes[field.to_sym]).utc) if attributes[field.to_sym]
      end
    end
  end
end
