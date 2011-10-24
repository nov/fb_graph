require 'spec_helper'

describe FbGraph::Connections::FriendLists do
  describe '#friend_lists' do
    it 'should return an array of FbGraph::FriendList' do
      mock_graph :get, 'matake/friendlists', 'users/friend_lists/matake', :access_token => 'access_token' do
        friend_lists = FbGraph::User.new('matake', :access_token => 'access_token').friend_lists
        friend_lists.each do |friend_list|
          friend_list.should be_instance_of(FbGraph::FriendList)
        end
      end
    end
  end

  describe '#friend_list!' do
    it 'should return FbGraph::FriendList' do
      mock_graph :post, 'me/friendlists', 'users/friend_lists/created', :access_token => 'access_token', :params => {
        :name => 'test'
      } do
        friend_list = FbGraph::User.me('access_token').friend_list! :name => 'test'
        friend_list.should be_instance_of FbGraph::FriendList
        friend_list.name.should == 'test'
      end
    end
  end
end