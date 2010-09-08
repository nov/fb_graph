module FbGraph
  class Group < Node
    include Connections::Feed
    include Connections::Members
    include Connections::Picture
    include Searchable

    attr_accessor :owner, :name, :description, :link, :venue, :privacy, :updated_time

    def initialize(identifier, attributes = {})
      super
      if (owner = attributes[:owner])
        @owner = FbGraph::User.new(owner.delete(:id), owner)
      end
      @name         = attributes[:name]
      @description  = attributes[:description]
      @link         = attributes[:link]
      @privacy      = attributes[:privacy]
      if attributes[:venue]
        @venue = FbGraph::Venue.new(attributes[:venue])
      end
      if attributes[:updated_time]
        @updated_time = Time.parse(attributes[:updated_time]).utc
      end
    end
  end
end