module FbGraph
  module Connections
    module Subscriptions
      # == Fetch current subscriptions
      # 
      #   app = FbGraph::Application.new(APP_ID, :secret => APP_SECRET)
      #   app.subscriptions
      #   => Array of FbGraph::Subscriptions
      def subscriptions(options = {})
        options[:access_token] ||= self.access_token
        subscriptions = self.connection :subscriptions, options
        subscriptions.map! do |subscription|
          Subscription.new subscription.merge(:access_token => options[:access_token])
        end
      end

      # == Subscribe
      # 
      # Subscriber have to setup PubSubHubbub subscriber endpoint.
      # See details at "Subscription Verification" in the Facebook API document.
      # ref) http://developers.facebook.com/docs/api/realtime
      # 
      #   app = FbGraph::Application.new(APP_ID, :secret => APP_SECRET)
      #   app.subscribe!(
      #     :object => "user",
      #     :fields => "name,email",
      #     :callback_url => "http://fbgraphsample.heroku.com/subscription",
      #     :verify_token => "Define by yourself"
      #   )
      #   => Array of FbGraph::Subscriptions
      def subscribe!(options = {})
        options[:access_token] ||= self.access_token
        post options.merge(:connection => :subscriptions)
      end

      # == Subscribe
      # 
      # Delete all of your subscriptions.
      # If you specify an object parameter, it will only delete the corresponding subscription.
      # ref) http://developers.facebook.com/docs/api/realtime
      # 
      #   app = FbGraph::Application.new(APP_ID, :secret => APP_SECRET)
      #   app.unsubscribe!(
      #     :object => "user"
      #   )
      #   => Array of FbGraph::Subscriptions
      def unsubscribe!(options = {})
        options[:access_token] ||= self.access_token
        destroy options.merge(:connection => :subscriptions)
      end
    end
  end
end