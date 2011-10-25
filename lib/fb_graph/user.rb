module FbGraph
  class User < Node
    include Connections::Accounts
    include Connections::AdAccounts
    include Connections::Activities
    include Connections::Albums
    include Connections::AppRequests
    include Connections::Books
    include Connections::Checkins
    include Connections::Events
    include Connections::Feed
    include Connections::FriendLists
    include Connections::FriendRequests
    include Connections::Friends
    include Connections::Family
    include Connections::Games
    include Connections::Groups
    include Connections::Home
    include Connections::Inbox
    include Connections::Interests
    include Connections::Links
    include Connections::Movies
    include Connections::Music
    include Connections::MutualFriends
    include Connections::Notes
    include Connections::Outbox
    include Connections::Payments
    include Connections::Permissions
    include Connections::Photos
    include Connections::Picture
    include Connections::Posts
    include Connections::Statuses
    include Connections::Tagged
    include Connections::Television
    include Connections::Threads
    include Connections::UserAchievements
    include Connections::UserLikes
    include Connections::Videos
    extend Searchable

    attr_accessor :name, :first_name, :middle_name, :last_name, :gender, :locale, :languages, :link, :username, :third_party_id, :timezone, :updated_time, :verified, :about, :bio, :birthday, :education, :email, :hometown, :interested_in, :location, :political, :favorite_teams, :quotes, :relationship_status, :religion, :significant_other, :video_upload_limits, :website, :work

    # NOTE: below are non-documented
    attr_accessor :sports,  :favorite_athletes, :inspirational_people, :address, :mobile_phone

    def initialize(identifier, attributes = {})
      super
      @name        = attributes[:name]
      @first_name  = attributes[:first_name]
      @middle_name = attributes[:middle_name]
      @last_name   = attributes[:last_name]
      @gender      = attributes[:gender]
      @locale      = attributes[:locale]
      @languages = []
      if attributes[:languages]
        attributes[:languages].each do |language|
          @languages << Page.new(language[:id], language)
        end
      end
      @link           = attributes[:link]
      @username       = attributes[:username]
      @third_party_id = attributes[:third_party_id]
      @timezone       = attributes[:timezone]
      if attributes[:updated_time]
        @updated_time = Time.parse(attributes[:updated_time]).utc
      end
      @verified = attributes[:verified]
      @about    = attributes[:about]
      @bio      = attributes[:bio]
      if attributes[:birthday]
        month, day, year = attributes[:birthday].split('/').collect(&:to_i)
        year ||= 0
        @birthday = Date.new(year, month, day)
      end
      @education = []
      if attributes[:education]
        attributes[:education].each do |education|
          @education << Education.new(education)
        end
      end
      @email = attributes[:email]
      if (hometown = attributes[:hometown])
        @hometown = Page.new(hometown[:id], hometown)
      end
      @interested_in = Array(attributes[:interested_in])
      if (location = attributes[:location])
        @location = Page.new(location[:id], location)
      end
      @political = attributes[:political]
      @favorite_teams = []
      if attributes[:favorite_teams]
        attributes[:favorite_teams].each do |favorite_team|
          @favorite_teams << Page.new(favorite_team[:id], favorite_team)
        end
      end
      @quotes = attributes[:quotes]
      @relationship_status = attributes[:relationship_status]
      @religion            = attributes[:religion]
      if (significant_other = attributes[:significant_other])
        @significant_other = User.new(significant_other[:id], significant_other)
      end
      # NOTE: couldn't find "video_upload_limits" in the response..
      #  @video_upload_limits = ??
      @website = attributes[:website]
      @work = []
      if attributes[:work]
        attributes[:work].each do |work|
          @work << Work.new(work)
        end
      end

      # NOTE: below are non-documented
      @sports = []
      if (sports = attributes[:sports])
        sports.each do |sport|
          @sports << Page.new(sport[:id], sport)
        end
      end
      @favorite_athletes = []
      if attributes[:favorite_athletes]
        attributes[:favorite_athletes].each do |favorite_athlete|
          @favorite_athletes << Page.new(favorite_athlete[:id], favorite_athlete)
        end
      end
      @inspirational_people = []
      if attributes[:inspirational_people]
        attributes[:inspirational_people].each do |inspirational_person|
          @inspirational_people << Page.new(inspirational_person[:id], inspirational_person)
        end
      end
      if attributes[:address]
        @address = Venue.new(attributes[:address])
      end
      @mobile_phone = attributes[:mobile_phone]
    end

    def self.me(access_token)
      new('me', :access_token => access_token)
    end

  end
end
