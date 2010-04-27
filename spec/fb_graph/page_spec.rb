require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Page, '.fetch' do
  before(:all) do
    fake_json(:get, 'platform', 'pages/platform_public')
    fake_json(:get, 'platform?token=token', 'pages/platform_private')
  end

  it 'should get page attributes' do
    page = FbGraph::Page.fetch('platform')
    page.identifier.should == '19292868552'
    page.name.should       == 'Facebook Platform'
    page.category.should   == 'Technology'
  end

  it 'should not require token' do
    FbGraph::Page.fetch('platform', :token => 'token').should == FbGraph::Page.fetch('platform')
  end
end