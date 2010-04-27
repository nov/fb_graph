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
      @start_time   = options[:start_time]
      @end_time     = options[:end_time]
      @location     = options[:location]
      if options[:venue]
        @venue = FbGraph::Venue.new(options[:venue])
      end
      @privacy      = options[:privacy]
      @updated_time = options[:updated_time]
    end
  end
end