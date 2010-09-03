module FbGraph
  class Event < Node
    attr_accessor :from, :tags, :place, :message, :coordinates, :application, :created_time

    def initialize(identifier, attributes = {})
      super
      if (from = attributes[:from])
        @from = FbGraph::User.new(from.delete(:id), from)
      end
      # TODO
      # Checkin isn't available in Japan yet, so I can't use this feature yet.
      # I'm very glad if someone helps me here.
    end
  end
end