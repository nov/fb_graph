require 'spec_helper'

describe FbGraph::Page do
  context 'for person category' do
    let :page do
      mock_graph :get, 'person', 'pages/categories/person'do
        FbGraph::Page.new('person').fetch
      end
    end
    subject { page }

    [
      :affiliation,
      :bio,
      :personal_info,
      :personal_interests
    ].each do |key|
      its(key) { should be_instance_of String }
    end

    its(:birthday) { should == Date.new(1980, 1, 1) }
  end
end