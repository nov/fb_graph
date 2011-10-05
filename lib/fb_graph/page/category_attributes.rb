module FbGraph
  class Page
    module CategoryAttributes
      @@attributes = {}
      @@attributes[:raw] = [
        :affiliation,
        :artists_we_like,
        :attire,
        :awards,
        :band_interests,
        :band_members,
        :bio,
        :booking_agent,
        :can_post,
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
        :link,
        :location,
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
      @@attributes[:symbols] = [
        :parking,
        :payment_options,
        :restaurant_services,
        :restaurant_specialties
      ]
      @@attributes[:date] = [
        :birthday,
        :built,
        :founded,
        :release_date
      ]
      @@attributes[:others] = [
        :checkin_count,
        :hours,
        :location
      ]
      attr_accessor *@@attributes.values.flatten

      def self.included(klass)
        klass.alias_method_chain :initialize, :category_specific_attributes
      end

      def initialize_with_category_specific_attributes(identifier, attributes = {})
        initialize_without_category_specific_attributes identifier, attributes
        @@attributes[:raw].each do |key|
          self.send :"#{key}=", attributes[key]
        end
        @@attributes[:symbols].each do |key|
          self.send :"#{key}=", []
          if attributes[key]
            self.send :"#{key}=", attributes[key].keys.collect(&:to_sym)
          end
        end
        @@attributes[:date].each do |key|
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
          utc_beginning_of_day = Time.now.utc.beginning_of_day
          attributes[:hours].each do |key, value|
            date, index, mode = key.split('_')
            index = index.to_i - 1
            date, mode = date.to_sym, mode.to_sym
            time = value.since(utc_beginning_of_day)
            time = Time.utc(1970, 1, 1, time.hour, time.min)
            @hours[date] ||= []
            @hours[date][index] ||= {}
            @hours[date][index][mode] = time
          end
        end
        if attributes[:location]
          @location = Venue.new(attributes[:location])
        end
      end
    end

    include CategoryAttributes
  end
end