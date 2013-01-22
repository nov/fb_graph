module FbGraph
  class AdGroupConversionStat < Node
    attr_accessor :adgroup_id, :values

    def initialize(identifier, attributes = {})
      super

      [:adgroup_id, :values].each do |field|
        send("#{field.to_s}=", attributes[field])
      end

      # Translate dates
      values.each do |value|
        %w(start_time end_time).each do |field|
          if val = value[field]
            # Handles integer timestamps and ISO8601 strings
            time = Time.at(val.to_i)
            value[field] = time
          end
        end
      end
    end

    def fetch(options={})
      raise "Not allowed to fetch an AdGroupConversionStat"
    end

    def update(options={})
      raise "Not allowed to update an AdGroupConversionStat"
    end

    def destroy(options={})
      raise "Not allowed to delete an AdGroupConversionStat"
    end

  end
end
