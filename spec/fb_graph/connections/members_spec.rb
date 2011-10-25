require 'spec_helper'

describe FbGraph::Connections::Members do
  let :member do
    FbGraph::User.new('member_id')
  end

  context 'when included in FbGraph::Group' do
    describe '#members' do
      it 'should return members as FbGraph::User' do
        mock_graph :get, 'emacs/members', 'groups/members/emacs_private', :access_token => 'access_token' do
          users = FbGraph::Group.new('emacs', :access_token => 'access_token').members
          users.each do |user|
            user.should be_instance_of FbGraph::User
          end
        end
      end
    end

    describe '#member!' do
      it :NOT_SUPPORTED_YET
    end

    describe '#unmember!' do
      it :NOT_SUPPORTED_YET
    end
  end

  context 'when included in FbGraph::FriendList' do
    describe '#members' do
      it 'should return members as FbGraph::User' do
        mock_graph :get, 'list_id/members', 'friend_lists/members/sample', :access_token => 'access_token' do
          users = FbGraph::FriendList.new('list_id', :access_token => 'access_token').members
          users.each do |user|
            user.should be_instance_of FbGraph::User
          end
        end
      end
    end

    describe '#member!' do
      it 'should return true' do
        mock_graph :post, 'list_id/members/member_id', 'true', :access_token => 'access_token' do
          FbGraph::FriendList.new('list_id', :access_token => 'access_token').member!(member).should be_true
        end
      end
    end

    describe '#unmember!' do
      it 'should return true' do
        mock_graph :delete, 'list_id/members/member_id', 'true', :access_token => 'access_token' do
          FbGraph::FriendList.new('list_id', :access_token => 'access_token').unmember!(member).should be_true
        end
      end
    end
  end
end