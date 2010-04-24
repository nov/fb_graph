require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Connections::Statuses, '#statuses' do

  describe 'when included by FbGraph::User' do
    before(:all) do
      fake_json(:get, 'arjun/statuses', 'users/statuses/arjun_public')
      fake_json(:get, 'arjun/statuses?access_token=access_token', 'users/statuses/arjun_private')
    end

    it 'should raise FbGraph::Unauthorized when no access_token given' do
      lambda do
        FbGraph::User.new('arjun').statuses
      end.should raise_exception(FbGraph::Unauthorized)
    end

    it 'should return statuses with pagination info' do
      statuses = FbGraph::User.new('arjun', :access_token => 'access_token').statuses
      statuses[:data].first.should == FbGraph::Status.new(
        '113559395341627',
        :from => {
          :id => '7901103',
          :name => 'Arjun Banker'
        },
        :message => 'http://www.facebook.com/photo.php?pid=60538827&l=79b44ffb74&id=7901103',
        :updated_time => '2010-04-21T21:10:16+0000'
      )
      statuses[:data].last.should == FbGraph::Status.new(
        '258870336453',
        :from => {
          :id => '7901103',
          :name => 'Arjun Banker'
        },
        :message => 'everything that is everywhere is in the Bharata, and what is not is nowhere',
        :updated_time => '2010-01-08T06:55:12+0000'
      )
      statuses[:data].each do |like|
        like.should be_instance_of(FbGraph::Status)
      end
    end
  end

  describe 'when included by FbGraph::Page' do
    before(:all) do
      fake_json(:get, 'platform/statuses', 'pages/statuses/platform_public')
      fake_json(:get, 'platform/statuses?access_token=access_token', 'pages/statuses/platform_private')
    end

    it 'should raise FbGraph::Unauthorized when no access_token given' do
      lambda do
        FbGraph::Page.new('platform').statuses
      end.should raise_exception(FbGraph::Unauthorized)
    end

    it 'should return statuses with pagination info' do
      statuses = FbGraph::Page.new('platform', :access_token => 'access_token').statuses
      statuses[:data].first.should == FbGraph::Status.new(
        '111081598927600',
        :from => {
          :id => '19292868552',
          :name => 'Facebook Platform',
          :category => 'Technology'
        },
        :message => 'Here\'s more information on the new social plugins announced at f8 today - http://bit.ly/db8ahS',
        :updated_time => '2010-04-21T20:17:04+0000'
      )
      statuses[:data].last.should == FbGraph::Status.new(
        '59328281651',
        :from => {
          :id => '19292868552',
          :name => 'Facebook Platform',
          :category => 'Technology'
        },
        :message => 'http://developers.facebook.com/news.php?blog=1&story=209',
        :updated_time => '2009-03-06T22:56:36+0000'
      )
      statuses[:data].each do |like|
        like.should be_instance_of(FbGraph::Status)
      end
    end
  end

end