module FbGraph
  class Page < Node
    include Connections::Admins
    include Connections::Albums
    include Connections::Blocked
    include Connections::Checkins
    include Connections::Conversations
    include Connections::Events
    include Connections::Feed
    include Connections::Groups
    include Connections::Insights
    include Connections::Likes
    include Connections::Links
    include Connections::Milestones
    include Connections::Notes
    include Connections::Photos
    include Connections::Picture
    include Connections::Posts
    include Connections::Questions
    include Connections::Settings
    include Connections::Statuses
    include Connections::Tabs
    include Connections::Tagged
    include Connections::Videos
    extend Searchable

    attr_accessor :name, :username, :category, :like_count, :talking_about_count, :perms

    def initialize(identifier, attributes = {})
      super
      [:name, :username, :category, :talking_about_count].each do |key|
        self.send :"#{key}=", attributes[key]
      end
      @like_count = attributes[:likes] || attributes[:fan_count]
      @perms = attributes[:perms]
    end
  end
end

require 'fb_graph/page/category_attributes'