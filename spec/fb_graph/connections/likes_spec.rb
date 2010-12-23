require File.join(File.dirname(__FILE__), '../../spec_helper')

describe FbGraph::Connections::Likes, '#likes' do
  context 'when included by FbGraph::User' do
    before do
      fake_json(:get, 'arjun/likes', 'users/likes/arjun_public')
      fake_json(:get, 'arjun/likes?access_token=access_token', 'users/likes/arjun_private')
    end

    context 'when no access_token given' do
      it 'should raise FbGraph::Unauthorized' do
        lambda do
          FbGraph::User.new('arjun').likes
        end.should raise_exception(FbGraph::Unauthorized)
      end
    end

    context 'when access_token is given' do
      it 'should return liked pages as FbGraph::Page' do
        likes = FbGraph::User.new('arjun', :access_token => 'access_token').likes
        likes.first.should == FbGraph::Page.new(
          '378209722137',
          :access_token => 'access_token',
          :name => 'Doing Things at the Last Minute',
          :category => '活動'
        )
        likes.each do |like|
          like.should be_instance_of(FbGraph::Page)
        end
      end
    end
  end

  context 'when included by FbGraph::Status' do
    context 'when cached collection exists' do
      before do
        fake_json(:get, 'with_likes?access_token=access_token', 'statuses/with_likes')
        @status = FbGraph::Status.new('with_likes').fetch(:access_token => 'access_token')
      end

      context 'when no options given' do
        it 'should not access to Graph API' do
          @status.likes.should == [FbGraph::User.new(
            '604578140',
            :access_token => 'access_token',
            :name => 'K Hiromi'
          )]
          @status.likes.next.should == []
          @status.likes.previous.should == []
        end
      end

      context 'when any options given' do
        it 'should access to Graph API' do
          lambda do
            @status.likes(:no_cache => true) # :no_cache has no meaning, just putting some value as options
          end.should raise_error(FakeWeb::NetConnectNotAllowedError)
          lambda do
            @status.likes(:limit => 10)
          end.should raise_error(FakeWeb::NetConnectNotAllowedError)
        end

        context 'when next/previous are obviously blank' do
          it 'should not access to Graph API' do
            @status.likes.next(:no_cache => true).should == []
            @status.likes.previous(:no_cache => true).should == []
          end
        end
      end
    end
  end
end