module FbGraph
  module Connections
    module AppRequests
      def app_requests(options = {})
        app_requests = self.connection(:apprequests, options)
        app_requests.map! do |app_request|
          AppRequest.new(app_request[:id], app_request.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end

      def app_request!(options = {})
        app_request_id = post options.merge(:connection => :apprequests)
        AppRequest.new(app_request_id, options.merge(
          :access_token => options[:access_token] || self.access_token
        ))
      end
    end
  end
end
