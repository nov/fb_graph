module FbGraph
  # Batch Request
  class BatchRequest < BatchBase
    attr_accessor :objects, :errors
    
    # Initialize object and run request
    def initialize(access_token, facebook_ids, options = {})
      super(access_token, options)
      self.objects = []
      self.errors = []
      timeout_and_retry { request(facebook_ids) } 
    end
    
    # Perform the request
    def request(facebook_ids)
      # No facebook_ids
      return if facebook_ids.blank?
      
      # Params for batch
      params = {:batch => facebook_ids.collect{|id| {:relative_url => id.to_s}}}
      
      begin
        # We would like to keep requests open in development mode, but disable during testing
        return if disable_facebook_interaction? && Rails.env.test?
        
        # Send the request to facebook
        response = current_client.post File.join(FbGraph::ROOT_URL), build_params(params)
        
        # Decode the response
        body = ActiveSupport::JSON.decode(response.body)
        
        # We expect an array from bulk request, if hash there is probably an error, so handle it
        handle_response {response} if body.kind_of?(Hash)
        
        # Gather all the body objects
        body_collection = body.collect {|r| r["body"]}
        
        # Decode each json body, and create the objects array
        body_collection.each do |result|
          next if result == "false"
          o = ActiveSupport::JSON.decode(result).with_indifferent_access
          objects << o if o[:error].blank? # If couldn't be found, then error object is returned do not include it
        end
        
        # Did we miss any, if it matters
        unless skip_missing_id_check
          diff = facebook_ids.collect{|id| id.to_i} - objects.collect{|o| o[:id].to_i}
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
