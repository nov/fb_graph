module FbGraph
  class Query < Node
    attr_accessor :access_token, :query

    def initialize(query, access_token = nil)
      @query = query
      @access_token = access_token
    end

    def fetch(access_token = nil)
      self.access_token ||= access_token
      handle_response do
        client.get build_endpoint
      end
    end

    private

    ENDPOINT = 'https://api.facebook.com/method/fql.query'
    def build_endpoint
      params = stringfy_params(
        :query => self.query,
        :access_token => self.access_token,
        :format => :json
      )
      params.delete_if do |k, v|
        v.blank?
      end
      ENDPOINT + "?#{params.to_query}"
    end

    def handle_response
      response = super do
        yield
      end
      case response
      when Hash
        if response[:error_code]
          raise APIError.new(response[:error_code], response[:error_msg])
        else
          response
        end
      else
        response
      end
    end

  end
end