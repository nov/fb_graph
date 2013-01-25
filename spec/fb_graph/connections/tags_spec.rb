require 'spec_helper'

describe FbGraph::Connections::Tags do
  let :photo do
    mock_graph :get, 'with_tags', 'photos/with_tags' do
      FbGraph::Photo.fetch('with_tags')
    end
  end

  describe '#tags' do
    context 'when cached' do
      it 'should not make request' do
        expect { photo.tags }.not_to request_to "#{photo.identifier}/tags"
      end
      it 'should make request when any options are specified' do
        expect { photo.tags(:no_cache => true) }.to request_to "#{photo.identifier}/tags"
      end
    end
  end

  describe FbGraph::Connections::Tags::Taggable do
    describe '#tag!' do
      it 'should post a tag' do
        expect do
          photo.tag!(:to => 'matake', :x => 50, :y => 50)
        end.to request_to "#{photo.identifier}/tags", :post
      end
    end
  end
end