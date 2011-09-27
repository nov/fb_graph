require 'spec_helper'

describe FbGraph::BroadTargetingCategory, '.new' do
  it 'should setup all supported attributes' do
    attributes = {
      :id => 6002714401172,
      :name => "Baby Boomers",
      :parent_category => "Family Status"
    }

    btc = FbGraph::BroadTargetingCategory.new(attributes.delete(:id), attributes)
    btc.identifier.should == 6002714401172
    btc.name.should == "Baby Boomers"
    btc.parent_category.should == "Family Status"
  end
end

