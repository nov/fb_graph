require 'spec_helper'

describe FbGraph::Connections::FriendRequests do
  it 'should return an Array of FriendRequest' do
    mock_graph :get, 'me/friendrequests', 'users/friend_requests/sample', :access_token => 'access_token' do
      friend_request = FbGraph::User.me('access_token').friend_requests.first
      friend_request.should be_a FbGraph::FriendRequest
      friend_request.from.should be_a FbGraph::User
      friend_request.to.should be_a FbGraph::User
    end
  end
end