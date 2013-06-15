module FbGraph
  class Page
    module CategoryAttributes
      @@category_attributes = {}
      @@category_attributes[:raw] = [
        :affiliation,
        :artists_we_like,
        :attire,
        :awards,
        :band_interests,
        :band_members,
        :bio,
        :booking_agent,
        :company_overview,
        :culinary_team,
        :current_location,
        :directed_by,
        :features,
        :general_info,
        :general_manager,
        :genre,
        :hometown,
        :influences,
        :is_community_page,
        :mission,
        :mpg,
        :personal_info,
        :personal_interests,
        :phone,
        :plot_outline,
        :press_contact,
        :price_range,
        :produced_by,
        :products,
        :public_transit,
        :record_label,
        :screenplay_by,
        :starring,
        :studio,
        :website,
        :written_by
      ]
      @@category_attributes[:symbols] = [
        :parking,
        :payment_options,
        :restaurant_services,
        :restaurant_specialties
      ]
      @@category_attributes[:date] = [
        :birthday,
        :built,
        :founded,
        :release_date
      ]
      @@category_attributes[:others] = [
        :checkin_count,
        :hours,
        :location
      ]
      attr_accessor *@@category_attributes.values.flatten

      def self.included(klass)
        klass.alias_method_chain :initialize, :category_specific_attributes
      end

      def initialize_with_category_specific_attributes(identifier, attributes = {})
        initialize_without_category_specific_attributes identifier, attributes
        @@category_attributes[:raw].each do |key|
          self.send :"#{key}=", attributes[key]
        end

        @@category_attributes[:symbols].each do |key|
          self.send :"#{key}=", []
          if attributes[key]
            self.send :"#{key}=", attributes[key].keys.collect(&:to_sym)
          end
        end
        @@category_attributes[:date].each do |key|
          date = if attributes[key]
            begin
              Date.parse attributes[key]
            rescue
              attributes[key]
            end
          end
          self.send :"#{key}=", date
        end
        @checkin_count = attributes[:checkins]
        @hours = {}
        if attributes[:hours]
          attributes[:hours].each do |key, value|
            date, index, mode = key.split('_')
            index = index.to_i - 1
            date, mode = date.to_sym, mode.to_sym
            if value.class == Fixnum
              # The Unix "time" returned is a weird approximation of the string value.
              # Example: "20:00" might be represented as 446400, which is 1970-01-05T20:00:00-08:00
              time = Time.at(value).in_time_zone("Pacific Time (US & Canada)")
            else
              time = Time.parse(value)
            end
            time = Time.utc(1970, 1, 1, time.hour, time.min)
            @hours[date] ||= []
            @hours[date][index] ||= {}
            @hours[date][index][mode] = time
          end
        end
        @location = case attributes[:location]
        when Hash
          Venue.new(attributes[:location])
        when String
          # ignore such non-structured data
        end
      end
    end

    include CategoryAttributes
  end
end
