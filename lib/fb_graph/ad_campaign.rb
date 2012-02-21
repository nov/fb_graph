module FbGraph
  class AdCampaign < Node
    include Connections::AdGroups

    attr_accessor :campaign_id, :account_id, :name, :start_time, :end_time, :updated_time, :daily_budget, :daily_imps, :campaign_status, :lifetime_budget

    def initialize(identifier, attributes = {})
      super
      set_attrs(attributes)
    end

    def update(options)
      response = super(options)

      if [1, "1", true].include?(options.symbolize_keys[:redownload])
        attributes = options.merge(response[:data][:campaigns][identifier].symbolize_keys)
        set_attrs(attributes)
      end

      response
    end

    protected

    def set_attrs(attributes)
      %w(campaign_id account_id name daily_budget daily_imps campaign_status lifetime_budget).each do |field|
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
