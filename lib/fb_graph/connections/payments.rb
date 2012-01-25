module FbGraph
  module Connections
    module Payments
      def payments(options = {})
        orders = self.connection :payments, options
        orders.map! do |order|
          Order.new order[:id], order.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
    end
  end
end