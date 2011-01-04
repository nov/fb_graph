require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Searchable do
  context 'when included by FbGraph::Page' do
    it 'should with type=page' do
      lambda do
        FbGraph::Page.search('FbGraph')
      end.should request_to('search?q=FbGraph&type=page')
    end
  end
end

describe FbGraph::Searchable::Result do
  before do
    fake_json :get, 'search?q=fbgraph&type=page', 'pages/search_fb_graph'
    fake_json :get, 'search?limit=25&offset=25&q=google&type=page', 'pages/search_google'
    @fb_graph = FbGraph::Page.search('fbgraph')
    @google_page2 = FbGraph::Page.search('google', :limit => 25, :offset => 25)
  end

  it 'should support pagination' do
    @fb_graph.next.should     == []
    @fb_graph.previous.should == []
    lambda do
      @google_page2.next
    end.should request_to('search?limit=25&offset=50&q=google&type=page')
    lambda do
      @google_page2.previous
    end.should request_to('search?limit=25&offset=0&q=google&type=page')
  end
end