require 'spec_helper'

describe FbGraph::Connections::Conversations do
  describe '#conversations' do
    let(:page) do
      FbGraph::Page.new('page_id', :access_token => 'page_token')
    end

    it 'should return an Array of FbGraph::Thread' do
      mock_graph :get, 'page_id/conversations', 'pages/conversations/list', :access_token => 'page_token' do
        conversations = page.conversations
        conversations.should be_instance_of FbGraph::Connection
        conversations.each do |conversation|
          conversation.should be_instance_of FbGraph::Thread
        end
      end
    end
  end
end