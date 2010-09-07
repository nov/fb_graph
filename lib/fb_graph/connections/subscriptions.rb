module FbGraph
  module Connections
    module Subscriptions
      def subscriptions(options = {})
        options[:access_token] ||= self.access_token || get_access_token(options[:secret])
        subscriptions = self.connection(:subscriptions, options)
        subscriptions.map! do |subscription|
          Subscription.new(subscription.delete(:id), subscription.merge(:access_token => options[:access_token]))
        end
      end

      def subscribe!(options = {})
        options[:access_token] ||= self.access_token || get_access_token(options[:secret])
        subscription = post(options.merge(:connection => 'subscriptions'))
        Subscription.new(subscription.delete(:id), subscription.merge(:access_token => options[:access_token]))
      end

      def unsubscribe!(options = {})
        options[:access_token] ||= self.access_token || get_access_token(options[:secret])
        destroy(options.merge(:connection => 'subscriptions'))
      end
    end
  end
end