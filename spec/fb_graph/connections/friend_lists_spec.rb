require 'spec_helper'

describe FbGraph::Connections::FriendLists, '#friend_lists' do
  it 'should return videos as FbGraph::FriendList' do
    mock_graph :get, 'matake/friendlists', 'users/friend_lists/matake', :params => {
      :access_token => 'access_token'
    } do
      friend_lists = FbGraph::User.new('matake', :access_token => 'access_token').friend_lists
      friend_lists.each do |friend_list|
        friend_list.should be_instance_of(FbGraph::FriendList)
      end
    end
  end
end