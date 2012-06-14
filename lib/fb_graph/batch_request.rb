module FbGraph
  class BatchRequest
    
    attr_reader :active, :actions, :options
    def initialize(options = {})
      @actions = []
      @options = options
      @active = true
    end
    def execute!
      @active = false
      responses = []
      @actions.each_slice(50) do |action_group|
        responses << FbGraph::Node.new('').update(:access_token => self.options[:access_token], :batch => action_group)
      end
      responses.flatten!(1)
      FbGraph::BatchResponse.new responses
    end

    def get(endpoint, params = {}, return_class=nil, &block)
      register :get, endpoint, params, return_class, &block
    end

    def post(endpoint, params = {}, return_class=nil, &block)
      register :post, endpoint, params, return_class, &block
    end

    def delete(endpoint, return_class=nil, &block)
      register :delete, endpoint, return_class, &block
    end

    private

    def register(method, endpoint, params = {}, return_class=nil, &block)
      @actions << {
        :method => method,
        :relative_url => endpoint.relative_url,
        :body => params.to_query,
        :return_class => return_class,
        :block => block
      }
      self
    end
  end
end
