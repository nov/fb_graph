require File.join(File.dirname(__FILE__), '../../spec_helper')

describe FbGraph::Connections::Home, '#home' do
  describe 'when included by FbGraph::User' do
    before(:all) do
      fake_json(:get, 'me/home', 'users/home/me_public')
      fake_json(:get, 'me/home?token=token', 'users/home/me_private')
      fake_json(:get, 'arjun/home', 'users/home/arjun_public')
      fake_json(:get, 'arjun/home?token=token', 'users/home/arjun_private')
    end

    it 'should raise FbGraph::Exception when no token given' do
      lambda do
        FbGraph::User.new('arjun').home
      end.should raise_exception(FbGraph::Exception)
    end

    it 'should raise FbGraph::Exception when identifier is not me' do
      lambda do
        FbGraph::User.new('arjun', :token => 'token').home
      end.should raise_exception(FbGraph::Exception)
    end

    it 'should raise FbGraph::NotFound when identifier is me and no token is given' do
      lambda do
        FbGraph::User.new('me').home
      end.should raise_exception(FbGraph::NotFound)
    end

    it 'should return posts when identifier is me and token is given' do
      posts = FbGraph::User.new('me', :token => 'token').home
      posts.first.should == FbGraph::Post.new(
        '634033380_112599768777073',
        :from => {
          :id => '634033380',
          :name => 'nishikokura hironobu'
        },
        :message => "こちらこそありがとうございました！僕はctrl+無変換ですｗRT @_eskm: @pandeiro245　こないだの日曜はありがとうございました！面白い内容でした。ちなみにfnrirってCapsLockで起動ですが、英数変換と同じボタンでどうしてます？起動を違うボタンに変更",
        :icon => 'http://photos-h.ak.fbcdn.net/photos-ak-sf2p/v43/23/2231777543/app_2_2231777543_2528.gif',
        :attribution => 'Twitter',
        :created_time => '2010-04-27T13:06:14+0000',
        :updated_time => '2010-04-27T13:06:14+0000'
      )
      posts.each do |post|
        post.should be_instance_of(FbGraph::Post)
      end
    end

  end
end