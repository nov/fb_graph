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
    include Connections::Events
    extend Searchable

    attr_accessor :name, :category

    def initialize(identifier, options = {})
      super
      @name     = options[:name]
      @category = options[:category]
    end
  end
end