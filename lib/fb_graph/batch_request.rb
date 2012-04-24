module FbGraph
  class BatchRequest < Array
    def execute!
      p self
      self.each do |task|
        p task
      end
      puts "EXCECUTE BATCH TASK!!"
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
      self << {
        :method => method,
        :endpoint => endpoint,
        :params => params
      }
    end
  end
end