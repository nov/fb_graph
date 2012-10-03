require 'spec_helper'

describe FbGraph::ReachEstimate, '.new' do
  let(:attributes) {
    {
      :users => 5503300,
      :bid_estimations => [
        {
          :location => 3,
          :cpc_min => 27,
          :cpc_median => 37,
          :cpc_max => 48,
          :cpm_min => 8,
          :cpm_median => 11,
          :cpm_max => 14
        }
      ],
      :imp_estimates => []
    }
  }

  let(:attributes_through_ad_group) {
    {
      :data => attributes
    }
  }
  it 'should setup all supported attributes' do
    estimate = FbGraph::ReachEstimate.new(attributes)
    estimate.users.should == 5503300
    estimate.cpc_min.should == 27
    estimate.cpc_median.should == 37
    estimate.cpc_max.should == 48
    estimate.cpm_min.should == 8
    estimate.cpm_median.should == 11
    estimate.cpm_max.should == 14
  end

  it 'should setup all supported attributes through AdGroup' do
    estimate = FbGraph::ReachEstimate.new(attributes_through_ad_group)
    estimate.users.should == 5503300
    estimate.cpc_min.should == 27
    estimate.cpc_median.should == 37
    estimate.cpc_max.should == 48
    estimate.cpm_min.should == 8
    estimate.cpm_median.should == 11
    estimate.cpm_max.should == 14
  end
end
