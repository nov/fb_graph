module FbGraph
  # Batch Update
  class BatchUpdate < BatchBase
    attr_accessor :success_objects, :error_objects
    
    # Initialize object and run request
    def initialize(access_token, objects, options = {})
      super(access_token, options)
      self.success_objects = []
      self.error_objects = []
      
      timeout_and_retry { update(objects) } 
    end
    
    # Perform the request
    def update(objects)
      # No Objects
      return if objects.blank?
      
      # Keep track of key/values we want to send to facebook
      update_params = objects.inject({}) do |p, o|
        # Get the list of updatable columns, the object MUST respond to facebook_actions_allowable_columns
        body_hash = o.facebook_actions_allowable_columns.inject({}) {|h, k| h[k.to_s.sub(/^api_/,"").to_sym] = o.send(k); h}
        
        # Translate the columns, if the object responds to facebook_actions_translated_columns
        o.facebook_actions_translated_columns.each {|k, v| body_hash[k.to_sym] = v if body_hash.include?(k.to_sym)} if o.respond_to?(:facebook_actions_translated_columns)
        
        # Remove any columns whos values are nil, we do not want to pass these to Facebook
        body_hash.delete_if{|k, v| v.nil?}
        
        p[o.facebook_key] = body_hash
        p
      end
      
      # Generate Call
      post_params = {
        :batch => update_params.collect do |k, v|
          { :method => "POST", :relative_url => k.to_s, :body => CGI.unescape(v.merge(:redownload => 1).to_query)}
        end
      }
      
      begin
        # Return if we are testing, do not make the call
        return if disable_facebook_interaction?
        
        # Send the request to facebook
        response = current_client.post File.join(FbGraph::ROOT_URL), build_params(post_params)
        
        # Decode the response
        body = ActiveSupport::JSON.decode(response.body)
        
        # We expect an array from bulk request, if hash there is probably an error, so handle it
        handle_response {response} if body.kind_of?(Hash)
        
        # Gather all the body objects
        body_collection = body.collect {|r| r["body"]}
        
        # Store objects to compare with later
        tmp_objects = {}
        tmp_error_objects = []
        
        # Decode each json body, and create the objects array
        body_collection.each do |result|
          next if result == "false"
          o = ActiveSupport::JSON.decode(result).with_indifferent_access
          if o[:error].blank?
            o["data"].each do |obj_name, data|
              tmp_objects[obj_name] ||= {}
              tmp_objects[obj_name].merge!(data)
            end
          end
        end
      rescue *[TypeError, NoMethodError] => e
        # Turn this into a regular exception
        raise_timeout_exception_unless_maximum_retries(Exception.new(400, "#{e.message}"))
      rescue *[MultiJson::DecodeError, JSON::ParserError, Exception] => e
        raise_timeout_exception_unless_maximum_retries(e)
      end
      
      # Iterate over the objects that were passed in, and determine if the update was successful
      objects.each do |o|
        if tmp_objects[o.facebook_type.pluralize].blank? || tmp_objects[o.facebook_type.pluralize][o.facebook_key.to_s].blank?
          tmp_error_objects << o
        else
          return_object = tmp_objects[o.facebook_type.pluralize][o.facebook_key.to_s]
          success_objects << o
        end  
      end
        
      # Try the failure objects one at a time
      # This will ensure that they are indeed invalid
      # And that we append the appropriate error message(s)
      tmp_error_objects.each do |o|
        begin
          o.save_to_facebook(:send_all_attributes => true) unless o.deleted?
          o.valid? # Remove any error messages
          success_objects << o 
        rescue ActiveRecord::RecordInvalid => e
          error_objects << o
        end
      end
    end  
  end
end
