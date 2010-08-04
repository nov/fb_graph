require File.join(File.dirname(__FILE__), '../../spec_helper')

context 'when included by FbGraph::User' do
  describe FbGraph::Connections::Likes, '#likes' do
    before(:all) do
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
end