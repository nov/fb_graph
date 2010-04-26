module FbGraph
  module Connections
    module Events
      def events(options = {})
        events = Collection.new(get(options.merge(:connection => 'events')))
        events.map! do |event|
          Event.new(event.delete(:id), event)
        end
      end
    end
  end
end