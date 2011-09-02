module FbGraph
  class Auth
    class VerificationFailed < BadRequest; end

    attr_accessor :client, :access_token, :user, :data

    def initialize(client_id, client_secret, options = {})
      @client = Rack::OAuth2::Client.new(
        :identifier             => client_id,
        :secret                 => client_secret,
        :host                   => URI.parse(ROOT_URL).host,
        :authorization_endpoint => '/oauth/authorize',
        :token_endpoint         => '/oauth/access_token',
        :redirect_uri           => options[:redirect_uri]
      )
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
        :client_id    => self.client.identifier,
        :redirect_uri => canvas_uri
      )
      params[:scope] = Array(params[:scope]).join(',') if params[:scope].present?
      endpoint.query = params.to_query
      endpoint.to_s
    end

    def from_cookie(cookie)
      self.data = Cookie.parse(client, cookie)
      get_access_token! data[:code]
      self
    end

    def from_signed_request(signed_request)
      self.data = SignedRequest.verify(client, signed_request)
      if self.data[:oauth_token]
        self.access_token = build_access_token(data)
        self.user = User.new(data[:user_id], :access_token => self.access_token)
      end
      self
    end

    def from_session_key(session_key)
      response = HTTPClient.new.post "#{ROOT_URL}/oauth/exchange_sessions", {:client_id => @client.identifier, :client_secret => @client.secret, :sessions => session_key}
      if response.body && self.data = JSON.parse(response.body)
        if self.data[0]
          self.access_token = build_access_token(self.data[0].with_indifferent_access)
        else
          # If the session key is unknown or there's an error, Facebook returns null
          self.access_token = nil
        end
      end
      self
    end

    private

    def get_access_token!(code)
      raise Unauthorized.new('No Authorization Code') unless code
      client.redirect_uri = ''
      client.authorization_code = code
      self.access_token = client.access_token!
      self.user = User.new(data[:user_id], :access_token => access_token)
      self
    end

    def build_access_token(data)
      expires_in = unless data[:expires].nil? || data[:expires].zero?
        data[:expires] - Time.now.to_i
      end
      Rack::OAuth2::AccessToken::Legacy.new(
        :access_token => data[:oauth_token] || data[:access_token],
        :expires_in   => expires_in
      )
    end
  end
end

require 'fb_graph/auth/cookie'
require 'fb_graph/auth/signed_request'
