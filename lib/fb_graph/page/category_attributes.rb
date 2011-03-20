module FbGraph
  class Page
    module CategoryAttributes
      @@attributes = {}
      @@attributes[:raw] = [
        :attire,
        :awards,
        :can_post,
        :company_overview,
        :culinary_team,
        :features,
        :general_info,
        :general_manager,
        :is_community_page,
        :link,
        :location,
        :mission,
        :mpg,
        :phone,
        :price_range,
        :products,
        :public_transit,
        :website
      ]
      @@attributes[:symbols] = [
        :parking,
        :payment_options,
        :restaurant_services,
        :restaurant_specialties
      ]
      @@attributes[:date] = [
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
          if attributes[key]
            value = Date.parse(attributes[key]) rescue attributes[key]
            self.send :"#{key}=", value
          end
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