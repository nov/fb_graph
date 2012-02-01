module Rack
  module OAuth2
    class Client
      class Grant
        class FbExchangeToken < Grant
          attr_required :fb_exchange_token
        end
      end
    end
  end
end