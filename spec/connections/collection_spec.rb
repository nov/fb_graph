require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Connections::Collection do
  before(:all) do
    fake_json(:get, 'platform/statuses', 'pages/statuses/platform_public')
    fake_json(:get, 'platform/statuses?access_token=access_token', 'pages/statuses/platform_private')
  end

  it 'should be a kind of Array with previous and next params' do
    statuses = FbGraph::Page.new('platform', :access_token => 'access_token').statuses
    statuses.should be_kind_of(Array)
    statuses.previous.should be_kind_of(Hash)
    statuses.next.should be_kind_of(Hash)
  end
end