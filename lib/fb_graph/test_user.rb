module FbGraph
  class TestUser < User
    attr_accessor :login_url, :password

    def initialize(identifier, attributes = {})
      super
      @login_url = attributes[:login_url]
      @password = attributes[:password]
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