require 'spec_helper'

describe FbGraph::Connections::Friends, '#friends' do
  context 'when included by FbGraph::User' do
    before do
      fake_json(:get, 'me/friends', 'users/friends/me_public', :status => [401, 'Unauthorized'])
      fake_json(:get, 'me/friends?access_token=access_token', 'users/friends/me_private')
      fake_json(:get, 'arjun/friends', 'users/friends/arjun_public', :status => [401, 'Unauthorized'])
      fake_json(:get, 'arjun/friends?access_token=access_token', 'users/friends/arjun_private', :status => [401, 'Unauthorized'])
    end

    context 'when no access_token given' do
      it 'should raise FbGraph::Unauthorized' do
        lambda do
          FbGraph::User.new('arjun').friends
        end.should raise_exception(FbGraph::Unauthorized)
      end
    end

    context 'when identifier is not me' do
      it 'should raise FbGraph::Unauthorized' do
        lambda do
          FbGraph::User.new('arjun', :access_token => 'access_token').friends
        end.should raise_exception(FbGraph::Unauthorized)
      end
    end

    context 'when identifier is me and no access_token is given' do
      it 'should raise FbGraph::Unauthorized' do
        lambda do
          FbGraph::User.new('me').friends
        end.should raise_exception(FbGraph::Unauthorized)
      end
    end

    context 'when identifier is me and access_token is given' do
      it 'should return friends as FbGraph::User' do
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