require File.join(File.dirname(__FILE__), '../../spec_helper')

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

    it 'should raise FbGraph::NotFound when identifier is me and no access_token is given' do
      lambda do
        FbGraph::User.new('me').home
      end.should raise_exception(FbGraph::NotFound)
    end

    it 'should return posts when identifier is me and access_token is given' do
      posts = FbGraph::User.new('me', :access_token => 'access_token').home
      posts.first.should == FbGraph::Post.new(
        '777639200_114261338604732',
        :from => {
          :id => '777639200',
          :name => 'Masahiro Kiura'
        },
        :message => "\"午前の試験監督の女の子が劇的に好みだった。細身色白、鼻筋通って目の大きいちょっと日本人離れしたタイプで、そう考えると嫁さんは実にストライクである。\" http://tumblr.com/xq3928azv",
        :icon => 'http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v43/23/2231777543/app_2_2231777543_2528.gif',
        :attribution => 'Twitter',
        :created_time => '2010-04-25T12:23:09+0000',
        :updated_time => '2010-04-25T12:23:09+0000'
      )
      posts.each do |post|
        post.should be_instance_of(FbGraph::Post)
      end
    end

  end
end