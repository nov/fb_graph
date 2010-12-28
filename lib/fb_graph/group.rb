module FbGraph
  class Group < Node
    include Connections::Feed
    include Connections::Members
    include Connections::Picture
    extend Searchable

    attr_accessor :owner, :name, :description, :link, :icon, :venue, :privacy, :version, :updated_time

    def initialize(identifier, attributes = {})
      super
      if (owner = attributes[:owner])
        @owner = User.new(owner.delete(:id), owner)
      end
      @name         = attributes[:name]
      @description  = attributes[:description]
      @link         = attributes[:link]
      @icon         = attributes[:icon]
      @privacy      = attributes[:privacy]
      @version      = attributes[:version]
      if attributes[:venue]
        @venue = Venue.new(attributes[:venue])
      end
      if attributes[:updated_time]
        @updated_time = Time.parse(attributes[:updated_time]).utc
      end
    end
  end
end