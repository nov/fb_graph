module FbGraph
  # Batch Request
  class BatchRequest < BatchBase
    attr_accessor :objects, :errors, :root_errors
    
    # Initialize object and run request
    def initialize(access_token, facebook_ids, options = {})
      super(access_token, options)
      self.objects = []
      self.errors = []
      self.root_errors = []
      timeout_and_retry { request(facebook_ids) } 
    end
    
    # Perform the request
    def request(facebook_ids)
      # No facebook_ids
      return if facebook_ids.blank?
      
      # Params for batch
      params = {:batch => facebook_ids.collect{|id| {:relative_url => id.to_s}}}
      
      begin
        # Was there nils returned in the request
        nil_returns = false
       
        # We would like to keep requests open in development mode, but disable during testing
        return if disable_facebook_interaction? && Rails.env.test?
        
        # Send the request to facebook
        response = current_client.post File.join(FbGraph::ROOT_URL), build_params(params)
        
        # Decode the response
        body = ActiveSupport::JSON.decode(response.body)
        
        # We expect an array from bulk request, if hash there is probably an error, so handle it
        handle_response {response} if body.kind_of?(Hash)
        
        # Gather all the body objects
        body_collection = body.inject([]) do |a, r|
          # Sometimes Facebook returns nil as a body, there is no additional infomation as to why so we will just skip it
          (r.blank?) ? nil_returns = true : a << r["body"]
          a
        end
        
        # Decode each json body, and create the objects array
        body_collection.each do |result|
          next if result == "false"
          o = ActiveSupport::JSON.decode(result).with_indifferent_access
          objects << o if o[:error].blank? # If couldn't be found, then error object is returned do not include it          
        end

        # Did we miss any
        diff = facebook_ids.collect{|id| id.to_i} - objects.collect{|o| o[:id].to_i} rescue []
        
        # If we had nil returns, then we want to raise exceptions to retry
        # If we've exausted our retry attempts, then we want to send a message 
        # to the root users only and not raise an exception
        if nil_returns
          raise Exception.new(400, "Missing ID(s) Going to retry") if retries < RETRY_COUNT
          root_errors << "NIL Body Returned for object(s) on attempt #{retries}\n\n Request: #{params}\n\nMISSING: #{diff}"
        end
        
        # Send errors if it matters
        unless skip_missing_id_check          
          errors << "The following ID(s) were not found in Facebook #{diff.join(',')}" unless diff.blank?
        end
      rescue *[TypeError, NoMethodError] => e
        # Turn this into a regular exception
        raise_timeout_exception_unless_maximum_retries(Exception.new(400, "#{e.message}"))
      rescue *[MultiJson::DecodeError, JSON::ParserError, Exception] => e
        raise_timeout_exception_unless_maximum_retries(e)
      end
    end
  end
end
