require 'spec_helper'

describe FbGraph::AdGroup, '.new' do
    attr_accessor :ad_id, :campaign_id, :name, :adgroup_status, :bid_type, :max_bid, :adgroup_id, :end_time, :start_time, :updated_time
  it 'should setup all supported attributes' do
    attributes = {
      :id => '6003590469668',
      :ad_id => 6003590469668,
      :campaign_id => 6003590468467,
      :name => 'Ad Group 1',
      :adgroup_status => 1,
      :bid_type => 1,
      :max_bid => 1000,
      :adgroup_id => 6003590469668,
      :end_time => "2011-09-10T00:00:00+00:00",
      :start_time => "2011-09-01T12:00:00-07:00",
      :updated_time => "2011-09-04T16:00:00+00:00"
    }
    ad_group = FbGraph::AdGroup.new(attributes.delete(:id), attributes)
    ad_group.identifier.should == "6003590469668"
    ad_group.ad_id.should == 6003590469668
    ad_group.campaign_id.should == 6003590468467
    ad_group.name.should == "Ad Group 1"
    ad_group.adgroup_status.should == 1
    ad_group.bid_type.should == 1
    ad_group.max_bid.should == 1000
    ad_group.adgroup_id.should == 6003590469668
    ad_group.end_time.should == Time.parse("2011-09-10T00:00:00+00:00")
    ad_group.start_time.should == Time.parse("2011-09-01T12:00:00-07:00")
    ad_group.updated_time.should == Time.parse("2011-09-04T16:00:00+00:00")
  end
end


describe FbGraph::AdGroup, '.fetch' do
  it 'should get the ad group' do
    mock_graph :get, '6003590469668', 'ad_groups/test_ad_group', :access_token => 'access_token' do
      ad_group = FbGraph::AdGroup.fetch('6003590469668', :access_token => 'access_token')

      ad_group.identifier.should == "6003590469668"
      ad_group.ad_id.should == 6003590469668
      ad_group.campaign_id.should == 6003590468467
      ad_group.name.should == "Ad Group 1"
      ad_group.adgroup_status.should == 1
      ad_group.bid_type.should == 1
      ad_group.max_bid.should == 1000
      ad_group.adgroup_id.should == 6003590469668
      ad_group.end_time.should == Time.parse("2011-09-10T00:00:00+00:00")
      ad_group.start_time.should == Time.parse("2011-09-01T12:00:00-07:00")
      ad_group.updated_time.should == Time.parse("2011-09-04T16:00:00+00:00")
    end
  end
end
