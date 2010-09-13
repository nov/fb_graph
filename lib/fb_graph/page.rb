module FbGraph
  class Page < Node
    include Connections::Feed
    include Connections::Picture
    include Connections::Tagged
    include Connections::Links
    include Connections::Photos
    include Connections::Groups
    include Connections::Albums
    include Connections::Statuses
    include Connections::Videos
    include Connections::Notes
    include Connections::Posts
    include Connections::Members
    include Connections::Events
    include Connections::Checkins
    extend Searchable

    attr_accessor :name, :username, :link, :category, :founded, :company_overview, :mission, :products, :fan_count, :location

    def initialize(identifier, attributes = {})
      super
      @name     = attributes[:name]
      @username = attributes[:username]
      @link     = attributes[:link]
      @category = attributes[:category]
      if (founded = attributes[:founded])
        @founded = Date.parse(founded) rescue Date.new(founded.to_i)
      end
      @company_overview = attributes[:company_overview]
      @mission  = attributes[:mission]
      if (products = attributes[:products])
        @products = products.split "\n"
      end
      @fan_count = attributes[:fan_count]
      if (location = attributes[:location])
        @venue = FbGraph::Venue.new(location)
      end
    end
  end
end