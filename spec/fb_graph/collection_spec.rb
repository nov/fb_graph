require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Collection, '.new' do
  before(:all) do
    fake_json(:get, 'platform/statuses?access_token=access_token', 'pages/statuses/platform_private')
  end

  it 'should return an array with pagination info' do
    statuses = FbGraph::Page.new('platform', :access_token => 'access_token').statuses.collection
    statuses.should be_kind_of(Array)
    statuses.previous.should be_kind_of(Hash)
    statuses.next.should be_kind_of(Hash)
  end
end