require 'spec_helper'

describe FbGraph::Connections::Admins do
  let(:page) { FbGraph::Page.new('FbGraph', :access_token => 'page_token') }
  context 'when given user is admin' do
    it 'should be true' do
      mock_graph :get, 'FbGraph/admins/matake', 'pages/admins/sample', :access_token => 'page_token' do
        page.admin?(FbGraph::User.new('matake')).should be_true
      end
    end
  end

  context 'otherwise' do
    it 'should be false' do
      mock_graph :get, 'FbGraph/admins/nov.matake', 'pages/admins/blank', :access_token => 'page_token' do
        page.admin?(FbGraph::User.new('nov.matake')).should be_false
      end
    end
  end
end