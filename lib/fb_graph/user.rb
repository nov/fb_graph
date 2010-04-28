module FbGraph
  class User < Node
    include Connections::Home
    include Connections::Feed
    include Connections::Tagged
    include Connections::Posts
    include Connections::Picture
    include Connections::Friends
    include Connections::Activities
    include Connections::Interests
    include Connections::Music
    include Connections::Books
    include Connections::Movies
    include Connections::Television
    include Connections::Likes
    include Connections::Photos
    include Connections::Albums
    include Connections::Videos
    include Connections::Groups
    include Connections::Statuses
    include Connections::Links
    include Connections::Notes
    include Connections::Events

    # TODO:
    # include Connections::Inbox
    # include Connections::Outbox
    # include Connections::Updates

    attr_accessor :name, :last_name, :first_name, :link, :about, :birthday, :work, :education, :email, :website

    def initialize(identifier, options = {})
      super
      @name       = options[:name]
      @last_name  = options[:last_name]
      @first_name = options[:first_name]
      @link       = options[:link]
      @about      = options[:about]
      @birthday   = options[:birthday]
      @work       = options[:work]
      @education  = options[:education]
      @email      = options[:email]
      @website    = options[:website]
    end

    def self.me(access_token)
      new('me', :access_token => access_token)
    end

  end
end
