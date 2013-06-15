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
    include Connections::Likes
    include Connections::Links
    include Connections::Movies
    include Connections::Music
    include Connections::MutualFriends
    include Connections::Notes
    include Connections::Notifications
    include Connections::Outbox
    include Connections::Payments
    include Connections::Permissions
    include Connections::Photos
    include Connections::Picture
    include Connections::Pokes
    include Connections::Posts
    include Connections::Questions
    include Connections::Scores
    include Connections::Statuses
    include Connections::SubscribedTo
    include Connections::Subscribers
    include Connections::Tagged
    include Connections::Television
    include Connections::Threads
    include Connections::UserAchievements
    include Connections::UserLikes
    include Connections::Videos
    include OpenGraph::UserContext
    extend Searchable

    @@attributes = {
      :raw => [
        :name, :first_name, :middle_name, :last_name, :gender,
        :locale, :link, :username, :third_party_id, :timezone,
        :verified, :about, :bio, :email, :political, :quotes,
        :relationship_status, :relationship, :video_upload_limits,
        :website, :mobile_phone, :installed, :rsvp_status,
        :security_settings, :currency, :religion
      ],
      :custom => [
        :languages, :like_count, :updated_time,
        :birthday, :education, :hometown, :interested_in, :location,
        :favorite_teams, :age_range, :significant_other,
        :work, :devices, :sports, :favorite_athletes, :inspirational_people,
        :address, :mobile_phone
      ]
    }

    attr_accessor *@@attributes.values.flatten

    def initialize(identifier, attributes = {})
      super
      @@attributes[:raw].each do |key|
        self.send :"#{key}=", attributes[key]
      end
      @languages = []
      if attributes[:languages]
        attributes[:languages].each do |language|
          @languages << Page.new(language[:id], language)
        end
      end
      if attributes[:updated_time]
        @updated_time = Time.parse(attributes[:updated_time]).utc
      end
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
      if (hometown = attributes[:hometown])
        @hometown = Page.new(hometown[:id], hometown)
      end
      @interested_in = Array(attributes[:interested_in])
      if (location = attributes[:location])
        @location = Page.new(location[:id], location)
      end
      @favorite_teams = []
      if attributes[:favorite_teams]
        attributes[:favorite_teams].each do |favorite_team|
          @favorite_teams << Page.new(favorite_team[:id], favorite_team)
        end
      end
      if (significant_other = attributes[:significant_other])
        @significant_other = User.new(significant_other[:id], significant_other)
      end
      @work = []
      if attributes[:work]
        attributes[:work].each do |work|
          @work << Work.new(work)
        end
      end
      @devices = []
      if attributes[:devices]
        attributes[:devices].each do |device|
          @devices << Device.new(device)
        end
      end
      @security_settings = attributes[:security_settings]
      if attributes[:age_range]
        @age_range = AgeRange.new(attributes[:age_range])
      end
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
    end

    def self.me(access_token)
      new('me', :access_token => access_token)
    end
  end
end
