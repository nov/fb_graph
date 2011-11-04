require 'spec_helper'

describe FbGraph::Connections::FriendRequests do
  it 'should return an Array of FriendRequest' do
    mock_graph :get, 'me/friendrequests', 'users/friend_requests/sample', :access_token => 'access_token' do
      friend_requests = FbGraph::User.me('access_token').friend_requests
      friend_requests.total_count.should == 1
      friend_requests.unread_count.should == 1
      friend_requests.updated_time.should == Time.parse('2011-10-31T03:38:55+0000')
      friend_request = friend_requests.first
      friend_request.should be_a FbGraph::FriendRequest
      friend_request.from.should be_a FbGraph::User
      friend_request.to.should be_a FbGraph::User
    end
  end
end