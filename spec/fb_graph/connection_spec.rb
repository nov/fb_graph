require 'spec_helper'

describe FbGraph::Connection, '.new' do
  it 'should return an array with connection info' do
    mock_graph :get, 'platform/statuses', 'pages/statuses/platform_private', :access_token => 'access_token' do
      page = FbGraph::Page.new('platform', :access_token => 'access_token')
      statuses = page.statuses
      statuses.should be_kind_of(Array)
      statuses.collection.should be_kind_of(FbGraph::Collection)
      statuses.owner.should == page
      statuses.connection.should == :statuses
    end
  end
end

describe FbGraph::Connection do
  it 'should be useful for pagenation' do
    me = FbGraph::User.new('me', :access_token => 'access_token')
    posts = nil
    mock_graph :get, 'me/home', 'users/home/me_private', :access_token => 'access_token' do
      posts = me.home
      posts.first.created_time.should == Time.parse('2010-04-27T13:06:14+0000')
      posts.last.created_time.should  == Time.parse('2010-04-27T11:07:48+0000')
    end
    mock_graph :get, 'me/home', 'users/home/me_private_previous', :access_token => '2227470867|2.WUnvvW0Q_ksjjVOCIEkEiQ__.3600.1272380400-579612276|Skfo-M8-vpId32OYv6xLZFlsToY.', :params => {
      :limit => '25',
      :since => '123456789'
    } do
      previous_posts = posts.previous
      previous_posts.first.created_time.should == Time.parse('2010-04-27T13:23:08+0000')
      previous_posts.last.created_time.should  == Time.parse('2010-04-27T13:10:56+0000')
    end
    mock_graph :get, 'me/home', 'users/home/me_private_next', :access_token => '2227470867|2.WUnvvW0Q_ksjjVOCIEkEiQ__.3600.1272380400-579612276|Skfo-M8-vpId32OYv6xLZFlsToY.', :params => {
      :limit => '25',
      :until => '123456789'
    } do
      next_posts = posts.next
      next_posts.first.created_time.should == Time.parse('2010-04-27T11:06:29+0000')
      next_posts.last.created_time.should  == Time.parse('2010-04-27T09:44:28+0000')
    end
    mock_graph :get, 'me/home', 'users/home/me_private_next', :access_token => 'access_token', :params => {
      :limit => '25',
      :until => '123456789'
    } do
      next_posts = posts.next(:access_token => 'access_token')
      next_posts.first.created_time.should == Time.parse('2010-04-27T11:06:29+0000')
      next_posts.last.created_time.should  == Time.parse('2010-04-27T09:44:28+0000')
    end
  end
end