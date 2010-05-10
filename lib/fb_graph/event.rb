module FbGraph
  class Event < Node
    include Connections::Feed
    include Connections::Noreply
    include Connections::Maybe
    include Connections::Invited
    include Connections::Attending
    include Connections::Declined
    include Connections::Picture

    attr_accessor :owner, :name, :description, :start_time, :end_time, :location, :venue, :privacy, :updated_time

    def initialize(identifier, options = {})
      super
      if (owner = options[:owner])
        @owner = FbGraph::User.new(owner.delete(:id), owner)
      end
      @name         = options[:name]
      @description  = options[:description]
      if options[:start_time]
        @start_time = Time.parse(options[:start_time])
      end
      if options[:end_time]
        @end_time = Time.parse(options[:end_time])
      end
      @location     = options[:location]
      @privacy      = options[:privacy]
      if options[:venue]
        @venue = FbGraph::Venue.new(options[:venue])
      end
      if options[:updated_time]
        @updated_time = Time.parse(options[:updated_time])
      end
    end
  end
end