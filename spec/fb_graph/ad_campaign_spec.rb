require 'spec_helper'

describe FbGraph::AdCampaign, '.new' do
  it 'should setup all supported attributes' do
    attributes = {
      :id => '6003266501234',
      :campaign_id => 6003266501234,
      :account_id => 12345566,
      :name => "Test Ad Campaign",
      :start_time => "2011-07-01T12:00:00+00:00",
      :end_time => "2011-07-14T16:00:00+00:00",
      :daily_budget => 20000,
      :campaign_status => 1,
      :lifetime_budget => 100000
    }
    ad_campaign = FbGraph::AdCampaign.new(attributes.delete(:id), attributes)
    ad_campaign.identifier.should == "6003266501234"
    ad_campaign.account_id.should == 12345566
    ad_campaign.name.should == "Test Ad Campaign"
    ad_campaign.start_time.should == Time.parse("2011-07-01T12:00:00Z")
    ad_campaign.end_time.should == Time.parse("2011-07-14T16:00:00Z")
    ad_campaign.daily_budget.should == 20000
    ad_campaign.campaign_status.should == 1
    ad_campaign.lifetime_budget.should == 100000
  end

  it 'should handle integer, string, or iso8601 timestamps' do
    t = Time.parse("2011-09-01T00:00:00Z")
    attributes = {
      :id => '6003266501234',
      :campaign_id => 6003266501234,
      :account_id => 12345566,
      :name => "Test Ad Campaign",
      :end_time => "2011-09-10T00:00:00Z",
      :daily_budget => 20000,
      :campaign_status => 1,
      :lifetime_budget => 100000
    }
    FbGraph::AdCampaign.new(attributes[:id], attributes.merge(:start_time => t.to_i)).start_time.should == t
    FbGraph::AdCampaign.new(attributes[:id], attributes.merge(:start_time => t.to_i.to_s)).start_time.should == t
    FbGraph::AdCampaign.new(attributes[:id], attributes.merge(:start_time => t.iso8601)).start_time.should == t
  end
end


describe FbGraph::AdCampaign, '.fetch' do
  it 'should get the ad campaign' do
    mock_graph :get, '16003266501234', 'ad_campaigns/test_ad_campaign', :access_token => 'access_token' do
      ad_campaign = FbGraph::AdCampaign.fetch('16003266501234', :access_token => 'access_token')

      ad_campaign.identifier.should == "6003266501234"
      ad_campaign.account_id.should == 12345566
      ad_campaign.name.should == "Test Ad Campaign"
      ad_campaign.start_time.should == Time.parse("2011-07-01T12:00:00Z")
      ad_campaign.end_time.should == Time.parse("2011-07-14T16:00:00Z")
      ad_campaign.daily_budget.should == 20000
      ad_campaign.campaign_status.should == 1
      ad_campaign.lifetime_budget.should == 100000
    end
  end
end
