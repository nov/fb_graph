module FbGraph
  class AdAccount < Node
    include Connections::AdCampaigns
    include Connections::AdGroups
    include Connections::AdCampaignStats
    include Connections::AdGroupStats
    include Connections::BroadTargetingCategories
    include Connections::ReachEstimates
    include Connections::AdConnectionObjects

    attr_accessor :account_id, :name, :account_status, :daily_spend_limit, :users, :currency, :timezone_id, :timezone_name, :capabilities, :account_groups

    def initialize(identifier, attributes = {})
      super

      %w(account_id name account_status daily_spend_limit users currency timezone_id timezone_name).each do |field|
        send("#{field}=", attributes[field.to_sym])
      end

      if attributes[:users]
        self.users = attributes[:users].collect { |u| FbGraph::AdUser.new(u["uid"], u) }
      end
    end
  end
end
