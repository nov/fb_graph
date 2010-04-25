require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Connections::Home, '#home' do
  describe 'when included by FbGraph::User' do
    before(:all) do
      fake_json(:get, 'me/home', 'users/home/me_public')
      fake_json(:get, 'me/home?access_token=access_token', 'users/home/me_private')
      fake_json(:get, 'arjun/home', 'users/home/arjun_public')
      fake_json(:get, 'arjun/home?access_token=access_token', 'users/home/arjun_private')
    end

    it 'should raise FbGraph::Exception when no access_token given' do
      lambda do
        FbGraph::User.new('arjun').home
      end.should raise_exception(FbGraph::Exception)
    end

    it 'should raise FbGraph::Exception when identifier is not me' do
      lambda do
        FbGraph::User.new('arjun', :access_token => 'access_token').home
      end.should raise_exception(FbGraph::Exception)
    end

    it 'shoud raise FbGraph::NotFound when identifier is me and no access_token is given' do
      lambda do
        FbGraph::User.new('me').home
      end.should raise_exception(FbGraph::NotFound)
    end

    it 'shoud return posts when identifier is me and access_token is given' do
      posts = FbGraph::User.new('me', :access_token => 'access_token').home
      posts.each do |post|
        post.should be_instance_of(FbGraph::Post)
      end
    end

  end
end