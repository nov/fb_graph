module FbGraph
  class Auth
    class VerificationFailed < FbGraph::Exception; end

    attr_accessor :client, :access_token, :user

    def initialize(client_id, client_secret, options = {})
      @client = OAuth2::Client.new(client_id, client_secret, options.merge(
        :site => FbGraph::ROOT_URL
      ))
      if options[:cookie].present?
        from_cookie(options[:cookie])
      end
    end

    def from_cookie(cookie)
      cookie = FbGraph::Auth::Cookie.parse(self.client, cookie)
      self.access_token = OAuth2::AccessToken.new(
        self.client,
        cookie[:access_token],
        cookie[:refresh_token],
        cookie[:expires]
      )
      self.user = FbGraph::User.new(cookie[:uid], :access_token => self.access_token)
      self
    end
  end
end

require 'fb_graph/auth/cookie'