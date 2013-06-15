require 'spec_helper'

describe FbGraph::TaggedObject do
  let :attributes do
    MultiJson.load(json).with_indifferent_access
  end
  let :json do
    <<-JSON
      {
        "id": "1575327134",
        "name": "Jr Nov",
        "offset": 43,
        "length": 6
      }
    JSON
  end

  it 'should setup all supported attributes' do
    tagged_object = FbGraph::TaggedObject.new attributes[:id], attributes
    tagged_object.identifier.should == '1575327134'
    tagged_object.name.should == 'Jr Nov'
    tagged_object.offset.should == 43
    tagged_object.length.should == 6
  end

  describe '#fetch' do
    context 'when tagged object is an User' do
      it 'should return User' do
        mock_graph :get, 'object_id', 'users/arjun_public' do
          object = FbGraph::TaggedObject.new('object_id').fetch
          object.should be_instance_of FbGraph::User
        end
      end
    end

    context 'when tagged object is a Page' do
      it 'should return Page' do
        mock_graph :get, 'object_id', 'pages/platform_public' do
          object = FbGraph::TaggedObject.new('object_id').fetch
          object.should be_instance_of FbGraph::Page
        end
      end
    end
  end
end