require 'patch/rack/oauth2/grant/fb_exchange_token'

module Rack
  module OAuth2
    class Client
      def fb_exchange_token=(access_token)
        @grant = Grant::FbExchangeToken.new(
          :fb_exchange_token => access_token
        )
      end
    end
  end
end