module FbGraph
  class Page
    module Categories
      module LocalBusiness
        attr_accessor :attire, :general_manager :hours, :parking, :payment_options, :phone, :price_range, :public_transit, :restaurant_services, :restaurant_specialties

        def self.included(klass)
          klass.alias_method_chain :initialize, :category_specific_attributes
        end

        def initialize_with_category_specific_attributes(identifier, attributes = {})
          initialize_without_category_specific_attributes identifier, attributes
          @attire = attributes[:attire]
          @general_manager = attributes[:general_manager]
          @phone = attributes[:phone]
          @price_range = attributes[:price_range]
          @public_transit = attributes[:public_transit]
          @hours = {}
          if attributes[:hours]
            utc_beginning_of_day = Time.now.utc.beginning_of_day
            attributes[:hours].each do |key, value|
              date, index, mode = key.split('_')
              date, mode = date.to_sym, mode.to_sym
              @hours[] ||= []
              @hours[date][index - 1] ||= {}
              @hours[date][index - 1][mode] = value.since(utc_beginning_of_day)
            end
          end
          [:parking, :payment_options, :restaurant_services, :restaurant_services].each do |attribute|
            self.attribute = []
            if attributes[attribute]
              self.attribute = attributes[attribute].keys.collect(&:to_sym)
            end
          end
        end
      end
    end
  end
end