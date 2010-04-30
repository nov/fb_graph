module FbGraph
  module Connections
    module Events
      def events(options = {})
        events = FbGraph::Collection.new(get(options.merge(:connection => 'events')))
        events.map! do |event|
          Event.new(event.delete(:id), event)
        end
      end

      def event!(options = {})
        event = post(options.merge(:connection => 'events'))
        Event.new(event.delete(:id), options.merge(event))
      end
    end
  end
end