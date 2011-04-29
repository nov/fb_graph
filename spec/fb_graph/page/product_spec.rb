require 'spec_helper'

describe FbGraph::Page do
  context 'for product category' do
    let :page do
      mock_graph :get, 'product', 'pages/categories/product' do
        FbGraph::Page.new('product').fetch
      end
    end
    subject { page }

    [
      :awards,
      :features,
      :link,
      :mission,
      :mpg,
      :picture,
      :products
    ].each do |key|
      its(key) { should be_instance_of String }
    end

    its(:built)        { should == 'Since 1980' }
    its(:founded)      { should == '1980' }
    its(:release_date) { should == Date.parse('Wed, 01 Oct 1980') }

    context 'when valid date format' do
      subject do
        FbGraph::Page.new('12345', :built => 'May 1980', :founded => 'Oct 1980')
      end
      its(:built)   { should == Date.parse('Thu, 01 May 1980') }
      its(:founded) { should == Date.parse('Wed, 01 Oct 1980') }
    end
  end
end