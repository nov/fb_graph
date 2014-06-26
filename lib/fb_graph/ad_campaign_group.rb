module FbGraph
  class AdCampaignGroup < Node
    include Connections::AdCampaigns
    include Connections::AdGroups

    ATTRS = [
      :account_id,
      :name,
      :objective,
      :campaign_group_status,
      :buying_type
    ]

    attr_accessor *ATTRS
    def initialize(identifier, attributes = {})
      super

      ATTRS.each do |field|
        send("#{field}=", attributes[field.to_sym])
      end
    end
  end
end
