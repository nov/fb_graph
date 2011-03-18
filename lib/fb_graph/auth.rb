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

    attr_accessor :client, :access_token, :user, :data

    def initialize(client_id, client_secret, options = {})
      @client = OAuth2::Client.new(client_id, client_secret, options.merge(
        :site => ROOT_URL
      ))
      if options[:cookie]
        from_cookie options[:cookie]
      elsif options[:signed_request]
        from_signed_request options[:signed_request]
      end
    end

    def authorized?
      self.access_token.present?
    end

    def authorize_uri(canvas_uri)
      endpoint = URI.parse SignedRequest::OAUTH_DIALOG_ENDPOINT
      endpoint.query = {
        :client_id => self.client.id,
        :redirect_uri => canvas_uri
      }.to_query
      endpoint.to_s
    end

    def from_cookie(cookie)
      data = Cookie.parse(self.client, cookie)
      self.access_token = build_access_token(data)
      self.user = User.new(data[:uid], :access_token => self.access_token)
      self.data = data
      self
    end

    def from_signed_request(signed_request)
      data = SignedRequest.verify(self.client, signed_request)
      if data[:oauth_token]
        self.access_token = build_access_token(data)
        self.user = User.new(data[:user_id], :access_token => self.access_token)
      end
      self.data = data
      self
    end

    private

    def build_access_token(data)
      expires_in = unless data[:expires].zero?
        data[:expires] - Time.now.to_i
      end
      OAuth2::AccessToken.new(
        self.client,
        data[:oauth_token] || data[:access_token],
        nil,
        expires_in
      )
    end
  end
end

require 'fb_graph/auth/cookie'
require 'fb_graph/auth/signed_request'