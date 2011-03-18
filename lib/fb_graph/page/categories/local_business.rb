module FbGraph
  class Page
    module Categories
      module LocalBusiness
        attr_accessor :attire, :general_manager, :hours, :parking, :payment_options, :phone, :price_range, :public_transit, :restaurant_services, :restaurant_specialties

        def self.included(klass)
          klass.alias_method_chain :initialize, :category_specific_attributes
        end

        def initialize_with_category_specific_attributes(identifier, attributes = {})
          initialize_without_category_specific_attributes identifier, attributes
          [:attire, :general_manager, :phone, :price_range, :public_transit].each do |key|
            self.send :"#{key}=", attributes[key]
          end
          [:parking, :payment_options, :restaurant_services, :restaurant_specialties].each do |key|
            self.send :"#{key}=", []
            if attributes[key]
              self.send :"#{key}=", attributes[key].keys.collect(&:to_sym)
            end
          end
          @hours = {}
          if attributes[:hours]
            utc_beginning_of_day = Time.now.utc.beginning_of_day
            attributes[:hours].each do |key, value|
              date, index, mode = key.split('_')
              index = index.to_i - 1
              date, mode = date.to_sym, mode.to_sym
              @hours[date] ||= []
              @hours[date][index] ||= {}
              @hours[date][index][mode] = value.since(utc_beginning_of_day)
            end
          end
        end
      end
    end
  end
end