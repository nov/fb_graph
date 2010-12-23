module FbGraph
  class Query
    attr_accessor :access_token, :query, :format

    def initialize(options = {})
      @query = options[:query]
      @format = options[:format] || :json
      @access_token = options[:access_token]
      @endpoint = File.join(FbGraph::ROOT_URL, 'method/fql.query')
    end

    def fetch(options = {})
      params = {
        :query => self.query,
        :format => slef.format
      }.merge(options)
      handle_response do
        RestClient.get(self.endpoint + "?#{params.to_query}")
      end
    end

    private

    def handle_response
      response = yield
      p response
      response
    end

  end
end