module FbGraph
  class BatchBase < Node
    # Accessors
    attr_accessor :retries, :skip_missing_id_check, :timeout

    DEFAULT_TIMEOUT = 240
    
    # Initialize Accessors
    def initialize(access_token, options = {})
      self.access_token = access_token
      self.retries = 0
      self.skip_missing_id_check = options[:skip_missing_id_check] || false
      self.timeout = options[:timeout] || DEFAULT_TIMEOUT
    end
    
    # Get the http client and extent the timeout's
    def current_client
      current_client = http_client
      current_client.send_timeout = self.timeout - 2
      current_client.receive_timeout = self.timeout - 2
      current_client
    end
    
    private
    
    # Determine if we are in testing mode, and do NOT want to send objects to Facebook
    def disable_facebook_interaction?
      return true if defined?(DISABLE_FACEBOOK_INTERACTION) && DISABLE_FACEBOOK_INTERACTION == true
      false
    end
    
    # When we receive an exception, retry
    def raise_timeout_exception_unless_maximum_retries(e)
      raise Timeout::Error if retries < FbGraph.retry_count # Treat all exceptions as timeout exceptions until retries are exhausted
      raise e # Retries exhausted, reraise exception
    end
    
    # Attempt to retry FbGraph.retry_count times when Timeout::Error
    def timeout_and_retry
      begin
        Timeout::timeout(self.timeout) { yield } 
      rescue Timeout::Error
        raise if (self.retries += 1) > FbGraph.retry_count
        sleep 10 # Wait for Facebook to recover.
        retry
      end
    end #end timeout_and_retry
  end
end
