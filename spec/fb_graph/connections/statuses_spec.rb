require File.join(File.dirname(__FILE__), '../../spec_helper')

describe FbGraph::Connections::Statuses, '#statuses' do

  describe 'when included by FbGraph::User' do
    before(:all) do
      fake_json(:get, 'arjun/statuses', 'users/statuses/arjun_public')
      fake_json(:get, 'arjun/statuses?token=token', 'users/statuses/arjun_private')
    end

    it 'should raise FbGraph::Unauthorized when no token given' do
      lambda do
        FbGraph::User.new('arjun').statuses
      end.should raise_exception(FbGraph::Unauthorized)
    end

    it 'should return statuses' do
      statuses = FbGraph::User.new('arjun', :token => 'token').statuses
      statuses.first.should == FbGraph::Status.new(
        '113559395341627',
        :from => {
          :id => '7901103',
          :name => 'Arjun Banker'
        },
        :message => 'http://www.facebook.com/photo.php?pid=60538827&l=79b44ffb74&id=7901103',
        :updated_time => '2010-04-21T21:10:16+0000'
      )
      statuses.each do |like|
        like.should be_instance_of(FbGraph::Status)
      end
    end
  end

  describe 'when included by FbGraph::Page' do
    before(:all) do
      fake_json(:get, 'platform/statuses', 'pages/statuses/platform_public')
      fake_json(:get, 'platform/statuses?token=token', 'pages/statuses/platform_private')
    end

    it 'should raise FbGraph::Unauthorized when no token given' do
      lambda do
        FbGraph::Page.new('platform').statuses
      end.should raise_exception(FbGraph::Unauthorized)
    end

    it 'should return statuses with pagination info' do
      statuses = FbGraph::Page.new('platform', :token => 'token').statuses
      statuses.first.should == FbGraph::Status.new(
        '111081598927600',
        :from => {
          :id => '19292868552',
          :name => 'Facebook Platform',
          :category => 'Technology'
        },
        :message => 'Here\'s more information on the new social plugins announced at f8 today - http://bit.ly/db8ahS',
        :updated_time => '2010-04-21T20:17:04+0000'
      )
      statuses.each do |like|
        like.should be_instance_of(FbGraph::Status)
      end
    end
  end

end