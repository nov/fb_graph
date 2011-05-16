module FbGraph
  module Connections
    module Payments
      def payments(options = {})
        options[:access_token] ||= self.access_token
        options[:access_token] ||= get_access_token(options[:secret]) if respond_to?(:get_access_token)
        orders = self.connection(:payments, options)
        orders.map! do |order|
          orders[:access_token] ||= options[:access_token] || self.access_token
          Order.new(order[:id], order)
        end
      end
    end
  end
end