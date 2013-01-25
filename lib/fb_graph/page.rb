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
    include Connections::Picture::Updatable
    include Connections::Posts
    include Connections::PromotablePosts
    include Connections::Questions
    include Connections::Settings
    include Connections::Statuses
    include Connections::Tabs
    include Connections::Tagged
    include Connections::Videos
    include Connections::Offers
    extend Searchable

    @@attributes = {
      :raw => [:name, :username, :category, :link, :talking_about_count, :perms, :is_published, :can_post],
      :custom => [:cover, :like_count]
    }

    attr_accessor *@@attributes.values.flatten

    def initialize(identifier, attributes = {})
      super
      @@attributes[:raw].each do |key|
        self.send :"#{key}=", attributes[key]
      end
      @link ||= "https://www.facebook.com/#{username || identifier}"
      @like_count = attributes[:likes] || attributes[:fan_count]
      @cover = if (cover = attributes[:cover])
        Cover.new cover[:cover_id], cover
      end
    end

    protected

    def page_access_token
      get({:fields => "access_token"})["access_token"]
    end
  end
end

require 'fb_graph/page/category_attributes'
