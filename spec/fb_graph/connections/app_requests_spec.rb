require File.join(File.dirname(__FILE__), '../../spec_helper')

describe FbGraph::Connections::AppRequests, '#app_requests' do
  before do
    fake_json(:get, 'me/apprequests?access_token=access_token', 'users/app_requests/me_private')
  end

  it 'should return notes as FbGraph::Note' do
    app_requests = FbGraph::User.me('access_token').app_requests
    app_requests.each do |app_request|
      app_request.should be_instance_of(FbGraph::AppRequest)
    end
  end
end
