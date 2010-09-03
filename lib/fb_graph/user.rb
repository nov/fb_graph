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
    # TODO
    # include Connections::Inbox
    # include Connections::Outbox
    # include Connections::Updates
    # include Connections::Accounts
    extend Searchable

    # TODO:
    # include Connections::Inbox
    # include Connections::Outbox
    # include Connections::Updates

    attr_accessor :first_name, :last_name, :name, :link, :about, :birthday, :work, :education, :email, :website, :hometown, :location, :bio, :quotes, :gender, :interested_in, :meeting_for, :relationship_status, :religion, :political, :verified, :significant_other, :timezone, :updated_time

    def initialize(identifier, options = {})
      super
      @first_name = options[:first_name]
      @last_name  = options[:last_name]
      @name       = options[:name]
      @link       = options[:link]
      @about      = options[:about]
      if options[:birthday]
        month, day, year = options[:birthday].split('/').collect(&:to_i)
        year ||= 0
        @birthday = Date.new(year, month, day)
      end
      @work = []
      if options[:work]
        options[:work].each do |work|
          @work << FbGraph::Work.new(work)
        end
      end
      @education = []
      if options[:education]
        options[:education].each do |education|
          @education << FbGraph::Education.new(education)
        end
      end
      @email   = options[:email]
      @website = options[:website].to_s.split("\n")
      if (hometown = options[:hometown])
        @hometown = FbGraph::Page.new(hometown.delete(:id), hometown)
      end
      if (location = options[:location])
        @location = FbGraph::Page.new(location.delete(:id), location)
      end
      @bio                 = options[:bio]
      @quotes              = options[:quotes]
      @gender              = options[:gender]
      @interested_in       = Array(options[:interested_in])
      @meeting_for         = Array(options[:meeting_for])
      @relationship_status = options[:relationship_status]
      @religion            = options[:religion]
      @political           = options[:political]
      @verified            = options[:verified]
      @significant_other   = options[:significant_other] # What's this??
      @timezone            = options[:timezone]
      if options[:updated_time]
        @updated_time = Time.parse(options[:updated_time]).utc
      end
    end

    def self.me(access_token)
      new('me', :access_token => access_token)
    end

  end
end
