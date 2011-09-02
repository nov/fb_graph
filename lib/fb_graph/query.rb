module FbGraph
  class Query < Node
    ENDPOINT = 'https://api.facebook.com/method/fql.query'

    attr_accessor :access_token, :query

    def initialize(query, access_token = nil)
      @query = query
      @access_token = access_token
    end

    def fetch(access_token = nil)
      handle_response do
        http_client.get ENDPOINT, :query => build_params(access_token)
      end
    end

    private

    def build_params(access_token)
      super(
        :query => self.query,
        :access_token => access_token || self.access_token,
        :format => :json
      )
    end

    def handle_response
      response = super do
        yield
      end
      case response
      when Hash
        if response[:error_code]
          raise Exception.new(response[:error_code], response[:error_msg])
        else
          response
        end
      else
        response
      end
    end

  end
end