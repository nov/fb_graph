module FbGraph
  class Event < Node
    include Connections::Feed
    include Connections::Noreply
    include Connections::Maybe
    include Connections::Invited
    include Connections::Attending
    include Connections::Declined
    include Connections::Picture
    extend Searchable

    attr_accessor :owner, :name, :description, :start_time, :end_time, :location, :venue, :privacy, :updated_time

    def initialize(identifier, attributes = {})
      super
      if (owner = attributes[:owner])
        @owner = User.new(owner[:id], owner)
      end
      @name        = attributes[:name]
      @description = attributes[:description]
      @location    = attributes[:location]
      @privacy     = attributes[:privacy]
      if (start_time = attributes[:start_time])
        @start_time = case start_time
        when String
          Time.parse(start_time)
        when Integer
          Time.at(start_time)
        end
      end
      if (end_time = attributes[:end_time])
        @end_time = case end_time
        when String
          Time.parse(end_time)
        when Integer
          Time.at(end_time)
        end
      end
      if attributes[:venue]
        @venue = Venue.new(attributes[:venue])
      end
      if attributes[:updated_time]
        @updated_time = Time.parse(attributes[:updated_time]).utc
      end
    end
  end
end