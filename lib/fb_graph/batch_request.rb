module FbGraph
  class BatchRequest
    
    attr_reader :active, :actions
    def initialize(options = {})
      @actions = []
      @options = options
      @active = true
    end
    def execute!
      @active = false
      @actions.each_slice(50) do |action_group|
        FbGraph::Node.new('', @options).update(:batch => action_group)
      end
    end

    def get(endpoint, params = {})
      register :get, endpoint, params
    end

    def post(endpoint, params = {})
      register :post, endpoint, params
    end

    def delete(endpoint)
      register :delete, endpoint
    end

    private

    def register(method, endpoint, params = {})
      @actions << {
        :method => method,
        :relative_url => endpoint.relative_url,
        :params => params
      }
      self
    end
  end
end
