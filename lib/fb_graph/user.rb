module FbGraph
  class User < Node
    include Connections::Accounts
    include Connections::Activities
    include Connections::Albums
    include Connections::Books
    include Connections::Checkins
    include Connections::Events
    include Connections::Feed
    include Connections::FriendLists
    include Connections::Friends
    include Connections::Groups
    include Connections::Home
    include Connections::Interests
    include Connections::Likes
    include Connections::Links
    include Connections::Movies
    include Connections::Music
    include Connections::Notes
    include Connections::Photos
    include Connections::Picture
    include Connections::Posts
    include Connections::Statuses
    include Connections::Tagged
    include Connections::Television
    include Connections::Videos
    # --
    # TODO
    # include Connections::Inbox
    # include Connections::Outbox
    # include Connections::Updates
    # ++
    extend Searchable

    attr_accessor :first_name, :last_name, :name, :link, :about, :birthday, :work, :education, :email, :website, :hometown, :location, :bio, :quotes, :gender, :interested_in, :meeting_for, :relationship_status, :religion, :political, :verified, :significant_other, :timezone, :updated_time

    def initialize(identifier, attributes = {})
      super
      @first_name = attributes[:first_name]
      @last_name  = attributes[:last_name]
      @name       = attributes[:name]
      @link       = attributes[:link]
      @about      = attributes[:about]
      if attributes[:birthday]
        month, day, year = attributes[:birthday].split('/').collect(&:to_i)
        year ||= 0
        @birthday = Date.new(year, month, day)
      end
      @work = []
      if attributes[:work]
        attributes[:work].each do |work|
          @work << Work.new(work)
        end
      end
      @education = []
      if attributes[:education]
        attributes[:education].each do |education|
          @education << Education.new(education)
        end
      end
      @email   = attributes[:email]
      @website = attributes[:website].to_s.split("\n")
      if (hometown = attributes[:hometown])
        @hometown = Page.new(hometown.delete(:id), hometown)
      end
      if (location = attributes[:location])
        @location = Page.new(location.delete(:id), location)
      end
      @bio                 = attributes[:bio]
      @quotes              = attributes[:quotes]
      @gender              = attributes[:gender]
      @interested_in       = Array(attributes[:interested_in])
      @meeting_for         = Array(attributes[:meeting_for])
      @relationship_status = attributes[:relationship_status]
      @religion            = attributes[:religion]
      @political           = attributes[:political]
      @verified            = attributes[:verified]
      @significant_other   = attributes[:significant_other] # What's this??
      @timezone            = attributes[:timezone]
      if attributes[:updated_time]
        @updated_time = Time.parse(attributes[:updated_time]).utc
      end
    end

    def self.me(access_token)
      new('me', :access_token => access_token)
    end

  end
end
