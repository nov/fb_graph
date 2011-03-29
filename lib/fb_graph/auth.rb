module FbGraph
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

    def authorize_uri(canvas_uri, options = {})
      endpoint = URI.parse SignedRequest::OAUTH_DIALOG_ENDPOINT
      params = options.merge(
        :client_id => self.client.id,
        :redirect_uri => canvas_uri
      )
      params[:scope] = Array(params[:scope]).join(',') if params[:scope].present?
      endpoint.query = params.to_query
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