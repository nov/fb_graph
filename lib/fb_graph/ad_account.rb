module FbGraph
  class AdAccount < Node
    include Connections::AdCampaigns
    include Connections::AdGroups
    include Connections::AdCampaignStats

    attr_accessor :account_id, :name, :account_status, :daily_spend_limit, :users, :currency, :timezone_id, :timezone_name, :capabilities, :account_groups

    def initialize(identifier, attributes = {})
      super

      %w(account_id name account_status daily_spend_limit currency timezone_id timezone_name).each do |field|
        send("#{field}=", attributes[field.to_sym])
      end
    end
  end
end
