require 'spec_helper'

describe FbGraph::Connections::AppRequests, '#app_requests' do
  it 'should return app_requests as FbGraph::AppRequest' do
    mock_graph :get, 'me/apprequests', 'users/app_requests/me_private', :access_token => 'access_token' do
      app_requests = FbGraph::User.me('access_token').app_requests
      app_requests.each do |app_request|
        app_request.should be_instance_of(FbGraph::AppRequest)
      end
    end
  end
end
