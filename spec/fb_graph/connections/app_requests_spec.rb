require 'spec_helper'

describe FbGraph::Connections::AppRequests do
  describe '#app_requests' do
    it 'should return an Array of FbGraph::AppRequest' do
      mock_graph :get, 'me/apprequests', 'users/app_requests/me_private', :access_token => 'access_token' do
        app_requests = FbGraph::User.me('access_token').app_requests
        app_requests.each do |app_request|
          app_request.should be_instance_of FbGraph::AppRequest
        end
      end
    end
  end

  describe '#app_request!' do
    it 'should return FbGraph::AppRequest' do
      mock_graph :post, 'me/apprequests', 'users/app_requests/created', :access_token => 'access_token', :params => {
        :message => 'Message', :data => 'Data'
      } do
        app_request = FbGraph::User.me('access_token').app_request! :message => 'Message', :data => 'Data'
        app_request.should be_instance_of FbGraph::AppRequest
        app_request.identifier.should == "158192394305537_579612276"
        app_request.message.should == 'Message'
        app_request.data.should == 'Data'
      end
    end
  end
end
