require File.join(File.dirname(__FILE__), '../../spec_helper')

describe FbGraph::Connections::Friends, '#friends' do
  describe 'when included by FbGraph::User' do
    before(:all) do
      fake_json(:get, 'me/friends', 'users/friends/me_public')
      fake_json(:get, 'me/friends?access_token=access_token', 'users/friends/me_private')
      fake_json(:get, 'arjun/friends', 'users/friends/arjun_public')
      fake_json(:get, 'arjun/friends?access_token=access_token', 'users/friends/arjun_private')
    end

    it 'should raise FbGraph::Exception when no access_token given' do
      lambda do
        FbGraph::User.new('arjun').friends
      end.should raise_exception(FbGraph::Exception)
    end

    it 'should raise FbGraph::Exception when identifier is not me' do
      lambda do
        FbGraph::User.new('arjun', :access_token => 'access_token').friends
      end.should raise_exception(FbGraph::Exception)
    end

    it 'should raise FbGraph::NotFound when identifier is me and no access_token is given' do
      lambda do
        FbGraph::User.new('me').friends
      end.should raise_exception(FbGraph::NotFound)
    end

    it 'should return posts when identifier is me and access_token is given' do
      users = FbGraph::User.new('me', :access_token => 'access_token').friends
      users.first.should == FbGraph::User.new(
        '6401',
        :name => 'Kirk McMurray'
      )
      users.each do |user|
        user.should be_instance_of(FbGraph::User)
      end
    end

  end
end