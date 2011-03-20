require File.join(File.dirname(__FILE__), '../../spec_helper')

describe FbGraph::Page do
  context 'for person category' do
    before do
      fake_json(:get, 'person', 'pages/categories/person')
    end

    let(:page) { FbGraph::Page.new('person').fetch }
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