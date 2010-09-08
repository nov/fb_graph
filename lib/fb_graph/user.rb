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
    # --
    # TODO
    # include Connections::Inbox
    # include Connections::Outbox
    # include Connections::Updates
    # ++
    include Connections::Accounts
    include Connections::Checkins
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
          @work << FbGraph::Work.new(work)
        end
      end
      @education = []
      if attributes[:education]
        attributes[:education].each do |education|
          @education << FbGraph::Education.new(education)
        end
      end
      @email   = attributes[:email]
      @website = attributes[:website].to_s.split("\n")
      if (hometown = attributes[:hometown])
        @hometown = FbGraph::Page.new(hometown.delete(:id), hometown)
      end
      if (location = attributes[:location])
        @location = FbGraph::Page.new(location.delete(:id), location)
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
