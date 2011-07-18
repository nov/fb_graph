require 'spec_helper'

describe FbGraph::Connections::Tabs do
  let(:page) { FbGraph::Page.new('FbGraph', :access_token => 'page_token') }

  describe '#tabs' do
    it 'should return tabs as FbGraph::Tab' do
      mock_graph :get, 'FbGraph/tabs', 'pages/tabs/fb_graph', :access_token => 'page_token' do
        page.tabs.each do |tab|
          tab.should be_a FbGraph::Tab
        end
      end
    end
  end

  describe '#tab!' do
    it 'should add a tab' do
      mock_graph :post, 'FbGraph/tabs', 'true', :access_token => 'page_token', :params => {
        :app_id => '12345'
      } do
        page.tab!(:app_id => 12345).should be_true
      end
    end
  end
end