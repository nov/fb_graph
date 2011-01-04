module FbGraph
  class TestUser < Node
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

    attr_accessor :login_url

    def initialize(identifier, attributes = {})
      super
      @login_url = attributes[:login_url]
    end

    def friend!(test_user)
      post(
        :access_token => self.access_token,
        :connection => :friends,
        :connection_scope => test_user.identifier
      )
      test_user.send :post, {
        :access_token => test_user.access_token,
        :connection => :friends,
        :connection_scope => self.identifier
      }
    end
  end
end