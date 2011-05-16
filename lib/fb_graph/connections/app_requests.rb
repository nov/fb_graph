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
    end
  end
end
