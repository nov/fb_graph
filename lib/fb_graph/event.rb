module FbGraph
  class Event < Node
    include Connections::Feed
    include Connections::Noreply
    include Connections::Maybe
    include Connections::Invited
    include Connections::Attending
    include Connections::Declined
    include Connections::Picture
    include Searchable

    attr_accessor :owner, :name, :description, :start_time, :end_time, :location, :venue, :privacy, :updated_time

    def initialize(identifier, options = {})
      super
      if (owner = options[:owner])
        @owner = FbGraph::User.new(owner.delete(:id), owner)
      end
      @name        = options[:name]
      @description = options[:description]
      @location    = options[:location]
      @privacy     = options[:privacy]
      if (start_time = options[:start_time])
        @start_time = case start_time
        when String
          Time.parse(start_time).utc
        when Fixnum
          Time.at(start_time).utc
        end
      end
      if (end_time = options[:end_time])
        @end_time = case end_time
        when String
          Time.parse(end_time).utc
        when Fixnum
          Time.at(end_time).utc
        end
      end
      if options[:venue]
        @venue = FbGraph::Venue.new(options[:venue])
      end
      if options[:updated_time]
        @updated_time = Time.parse(options[:updated_time]).utc
      end
    end
  end
end