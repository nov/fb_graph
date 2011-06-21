require 'spec_helper'

describe FbGraph::Connections::Docs do
  describe '#docs' do
    it 'should return docs as FbGraph::Doc' do
      mock_graph :get, 'my_group/docs', 'groups/docs/private', :access_token => 'access_token' do
        docs = FbGraph::Group.new('my_group', :access_token => 'access_token').docs
        docs.each do |doc|
          doc.should be_instance_of(FbGraph::Doc)
        end
      end
    end
  end
end