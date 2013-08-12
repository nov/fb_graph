module FbGraph
  class Group < Node
    include Connections::Docs
    include Connections::Events
    include Connections::Feed
    include Connections::Members
    include Connections::Picture
    include Connections::Videos
    extend Searchable

    attr_accessor :owner, :name, :email, :description, :link, :icon, :privacy, :version, :updated_time

    def initialize(identifier, attributes = {})
      super
      if (owner = attributes[:owner])
        @owner = User.new(owner[:id], owner)
      end
      @name         = attributes[:name]
      @email        = attributes[:email]
      @description  = attributes[:description]
      @link         = attributes[:link]
      @icon         = attributes[:icon]
      @privacy      = attributes[:privacy]
      @version      = attributes[:version]
      if attributes[:updated_time]
        @updated_time = Time.parse(attributes[:updated_time]).utc
      end
    end
  end
end
