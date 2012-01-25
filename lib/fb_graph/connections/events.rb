module FbGraph
  module Connections
    module Events
      def events(options = {})
        events = self.connection :events, options
        events.map! do |event|
          Event.new event[:id], event.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      def event!(options = {})
        event = post options.merge(:connection => :events)
        Event.new event[:id], options.merge(event).merge(
          :access_token => options[:access_token] || self.access_token
        )
      end
    end
  end
end