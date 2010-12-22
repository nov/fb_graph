require File.join(File.dirname(__FILE__), '../../spec_helper')

describe FbGraph::Connections::FriendLists, '#friend_lists' do
  before(:all) do
    fake_json(:get, 'matake/friendlists?access_token=access_token', 'users/friend_lists/matake')
  end

  it 'should return videos as FbGraph::FriendList' do
    friend_lists = FbGraph::User.new('matake', :access_token => 'access_token').friend_lists
    friend_lists.each do |friend_list|
      friend_list.should be_instance_of(FbGraph::FriendList)
    end
  end
end