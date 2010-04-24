require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Connections::Likes, '#likes' do
  describe 'when included by FbGraph::User' do
    before(:all) do
      fake_json(:get, 'arjun/likes', 'users/likes/arjun_public')
      fake_json(:get, 'arjun/likes?access_token=access_token', 'users/likes/arjun_private')
    end

    it 'should raise FbGraph::Unauthorized when no access_token given' do
      lambda do
        FbGraph::User.new('arjun').likes
      end.should raise_exception(FbGraph::Unauthorized)
    end

    it 'should return liked pages with pagination info' do
      likes = FbGraph::User.new('arjun', :access_token => 'access_token').likes
      likes[:data].first.should == FbGraph::Page.new(
        '378209722137',
        :name => 'Doing Things at the Last Minute',
        :category => '活動'
      )
      likes[:data].last.should == FbGraph::Page.new(
        '329322570299',
        :name => 'Dirtybird Records',
        :category => 'Products_other'
      )
      likes[:data].each do |like|
        like.should be_instance_of(FbGraph::Page)
      end
    end
  end
end