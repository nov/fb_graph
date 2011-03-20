module FbGraph
  class Page < Node
    include Connections::Albums
    include Connections::Checkins
    include Connections::Events
    include Connections::Feed
    include Connections::Groups
    include Connections::Insights
    include Connections::Links
    include Connections::Notes
    include Connections::Photos
    include Connections::Picture
    include Connections::Posts
    include Connections::Statuses
    include Connections::Tagged
    include Connections::Videos
    extend Searchable

    attr_accessor :name, :username, :category, :like_count

    def initialize(identifier, attributes = {})
      super
      [:name, :username, :category].each do |key|
        self.send :"#{key}=", attributes[key]
      end
      @like_count = attributes[:likes] || attributes[:fan_count]
    end
  end
end

require 'fb_graph/page/category_attributes'