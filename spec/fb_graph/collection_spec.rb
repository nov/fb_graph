require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Collection, '#new' do
  before(:all) do
    fake_json(:get, 'platform/statuses?access_token=access_token', 'pages/statuses/platform_private')
  end

  it 'should return an array with pagination info' do
    statuses = FbGraph::Page.new('platform', :access_token => 'access_token').statuses
    statuses.should be_kind_of(Array)
    statuses.previous.should be_kind_of(Hash)
    statuses.next.should be_kind_of(Hash)
  end
end

describe FbGraph::Collection do
  before(:all) do
    fake_json(:get, 'me/home?access_token=access_token', 'users/home/me_private')
    fake_json(:get, 'me/home?limit=25&since=2010-04-27T13%3A06%3A14%2B0000&access_token=access_token', 'users/home/me_private_previous')
    fake_json(:get, 'me/home?limit=25&access_token=access_token&until=2010-04-27T11%3A07%3A48%2B0000', 'users/home/me_private_next')
  end

  it 'should be useful for pagenation' do
    me = FbGraph::User.new('me', :access_token => 'access_token')
    posts = me.home
    posts.first.created_time.should == Time.parse('2010-04-27T13:06:14+0000')
    posts.last.created_time.should  == Time.parse('2010-04-27T11:07:48+0000')
    previous_posts = me.home(posts.previous)
    previous_posts.first.created_time.should == Time.parse('2010-04-27T13:23:08+0000')
    previous_posts.last.created_time.should  == Time.parse('2010-04-27T13:10:56+0000')
    next_posts = me.home(posts.next)
    next_posts.first.created_time.should == Time.parse('2010-04-27T11:06:29+0000')
    next_posts.last.created_time.should  == Time.parse('2010-04-27T09:44:28+0000')
  end

end