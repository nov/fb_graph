require 'spec_helper'

describe FbGraph::Searchable do
  describe '.search' do
    context 'when included by FbGraph::Page' do
      it 'should with type=page' do
        lambda do
          FbGraph::Searchable.search('FbGraph')
        end.should request_to('search?q=FbGraph')
      end
    end
  end

  describe '#search' do
    context 'when included by FbGraph::Page' do
      it 'should with type=page' do
        lambda do
          FbGraph::Page.search('FbGraph')
        end.should request_to('search?q=FbGraph&type=page')
      end
    end
  end
end

describe FbGraph::Searchable::Result do
  let :fb_graph do
    mock_graph :get, 'search?q=fbgraph&type=page', 'pages/search_fb_graph' do
      FbGraph::Page.search('fbgraph')
    end
  end
  let :google_page2 do
    mock_graph :get, 'search?limit=25&offset=25&q=google&type=page', 'pages/search_google' do
      FbGraph::Page.search('google', :limit => 25, :offset => 25)
    end
  end

  it 'should support pagination' do
    fb_graph.next.should     == []
    fb_graph.previous.should == []
    lambda do
      google_page2.next
    end.should request_to('search?limit=25&offset=50&q=google&type=page')
    lambda do
      google_page2.previous
    end.should request_to('search?limit=25&offset=0&q=google&type=page')
  end
end