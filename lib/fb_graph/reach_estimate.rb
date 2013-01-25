module FbGraph
  class ReachEstimate < Node

    attr_accessor :users, :cpc_max, :cpc_median, :cpc_min, :cpm_max, :cpm_median, :cpm_min

    def initialize(attributes = {})
      super

      # everything in a data node when getting reach estimate through an AdGroup
      attributes = attributes[:data] if attributes[:data]

      %w(users).each do |field|
        send("#{field}=", attributes[field.to_sym])
      end

      %w(cpc_min cpc_median cpc_max cpm_min cpm_median cpm_max).each do |field|
        send("#{field}=", attributes[:bid_estimations][0][field.to_sym])
      end
    end
  end
end

