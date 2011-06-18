module FbGraph
  module Connections
    module Payments
      def payments(options = {})
        options[:access_token] ||= self.access_token
        orders = self.connection(:payments, options)
        orders.map! do |order|
          orders[:access_token] ||= options[:access_token] || self.access_token
          Order.new(order[:id], order)
        end
      end
    end
  end
end