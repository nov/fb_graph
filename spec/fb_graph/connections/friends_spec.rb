require 'spec_helper'

describe FbGraph::Connections::Friends, '#friends' do
  context 'when included by FbGraph::User' do
    context 'when no access_token given' do
      it 'should raise FbGraph::Unauthorized' do
        mock_graph :get, 'arjun/friends', 'users/friends/arjun_public', :status => [401, 'Unauthorized'] do
          lambda do
            FbGraph::User.new('arjun').friends
          end.should raise_exception(FbGraph::Unauthorized)
        end
      end
    end

    context 'when identifier is not me' do
      it 'should raise FbGraph::Unauthorized' do
        mock_graph :get, 'arjun/friends', 'users/friends/arjun_private', :access_token => 'access_token', :status => [401, 'Unauthorized'] do
          lambda do
            FbGraph::User.new('arjun', :access_token => 'access_token').friends
          end.should raise_exception(FbGraph::Unauthorized)
        end
      end
    end

    context 'when identifier is me and no access_token is given' do
      it 'should raise FbGraph::Unauthorized' do
        mock_graph :get, 'me/friends', 'users/friends/me_public', :status => [401, 'Unauthorized'] do
          lambda do
            FbGraph::User.new('me').friends
          end.should raise_exception(FbGraph::Unauthorized)
        end
      end
    end

    context 'when identifier is me and access_token is given' do
      it 'should return friends as FbGraph::User' do
        mock_graph :get, 'me/friends', 'users/friends/me_private', :access_token => 'access_token' do
          users = FbGraph::User.new('me', :access_token => 'access_token').friends
          users.first.should == FbGraph::User.new(
            '6401',
            :access_token => 'access_token',
            :name => 'Kirk McMurray'
          )
          users.each do |user|
            user.should be_instance_of(FbGraph::User)
          end
        end
      end
    end
  end
end