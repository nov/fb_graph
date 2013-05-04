module FbGraph
  class Query < Node
    attr_accessor :query

    def initialize(query, access_token = nil)
      super 'fql', :access_token => access_token
      @query = query
    end

    def fetch(params = {})
      handle_response do
        http_client.get endpoint, build_params(params)
      end
    end

    private

    def build_params(params)
      _query_ = if query.is_a?(Hash)
        query.to_json
      else
        query
      end
      params[:access_token] ||= self.access_token
      super params.merge(:q => _query_)
    end

    def handle_response
      response = super do
        yield
      end
      collection = Collection.new response
      if self.query.is_a?(Hash)
        collection.inject({}) do |results, result|
          results.merge(
            result['name'] => result['fql_result_set']
          )
        end.with_indifferent_access
      else
        collection
      end
    end

  end
end