module FbGraph
  # = Parse & verify facebook auth cookie
  # 
  # Used with Facebook JavaScript SDK
  # 
  #   app = FbGraph::Auth.new(APP_ID, APP_SECRET)
  #   app.from_cookie(cookie_hash)
  #   auth.access_token
  #   # => OAuth2::AccessToken (not String!)
  #   auth.user # only initialized
  #   auth.user.fetch # fetch whole profile
  # 
  # This method is called automatically if cookie is given when initializing
  # 
  #   auth = FbGraph::Auth.new(APP_ID, APP_SECRET, :cookie => {..})
  #   auth.access_token # already parsed
  class Auth
    class VerificationFailed < Exception; end

    attr_accessor :client, :access_token, :user

    def initialize(client_id, client_secret, options = {})
      @client = OAuth2::Client.new(client_id, client_secret, options.merge(
        :site => ROOT_URL
      ))
      if options[:cookie].present?
        from_cookie(options[:cookie])
      end
    end

    def from_cookie(cookie)
      cookie = Auth::Cookie.parse(self.client, cookie)
      expires_in = unless cookie[:expires].zero?
        cookie[:expires] - Time.now.to_i
      end
      self.access_token = OAuth2::AccessToken.new(
        self.client,
        cookie[:access_token],
        cookie[:refresh_token],
        expires_in
      )
      self.user = User.new(cookie[:uid], :access_token => self.access_token)
      self
    end

    def from_signed_request(signed_request)
      data = Auth::SignedRequest.verify(self.client, signed_request)
      expires_in = unless data[:expires].zero?
        data[:expires] - Time.now.to_i
      end
      self.access_token = OAuth2::AccessToken.new(
        self.client,
        data[:oauth_token],
        nil,
        expires_in
      )
      self.user = User.new(data[:user_id], :locale => data[:locale], :access_token => self.access_token)
      self
    end
  end
end

require 'fb_graph/auth/cookie'