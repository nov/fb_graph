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
        @owner = User.new(owner.delete(:id), owner)
      end
      @name        = attributes[:name]
      @description = attributes[:description]
      @location    = attributes[:location]
      @privacy     = attributes[:privacy]
      if attributes[:start_time]
        @start_time = convert_time(attributes[:start_time])
      end
      if attributes[:end_time]
        @end_time = convert_time(attributes[:end_time])
      end
      if attributes[:venue]
        @venue = Venue.new(attributes[:venue])
      end
      if attributes[:updated_time]
        @updated_time = convert_time(attributes[:updated_time])
      end
    end

    private
    def convert_time(time)
      case time
      when String
        Time.parse(time)
      when Fixnum
        Time.at(time)
      when Time
        time
      end
    end
  end
end
