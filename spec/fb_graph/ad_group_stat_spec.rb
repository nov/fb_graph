require 'spec_helper'

describe FbGraph::AdGroupStat, '.new' do
  it 'should setup all supported attributes' do
    attributes = {
      :id => "6005443999375/stats/0/1348256188",
      :start_time => "2012-09-21T00:00:00+0000", 
      :end_time => "2012-09-21T23:59:59+0000", 
      :adgroup_id => 6005443999375, 
      :campaign_id => 6003590468467,
      :clicks => 13, 
      :impressions => 33368, 
      :spent => 894, 
      :social_clicks => 5, 
      :social_impressions =>  10561, 
      :social_spent => 339, 
      :social_unique_clicks => 0, 
      :social_unique_impressions => 0, 
      :actions => {:like => 1},
      :unique_clicks =>  0, 
      :unique_impressions =>  0,
      :connections => 1, 
      :newsfeed_position => 2
    }

    ad_group_stat = FbGraph::AdGroupStat.new(attributes.delete(:id), attributes)
    ad_group_stat.identifier.should == "6005443999375/stats/0/1348256188"
    ad_group_stat.start_time.should == Time.parse("2012-09-21T00:00:00+0000") 
    ad_group_stat.end_time.should == Time.parse("2012-09-21T23:59:59+0000")
    ad_group_stat.adgroup_id.should == 6005443999375 
    ad_group_stat.campaign_id.should == 6003590468467
    ad_group_stat.clicks.should == 13 
    ad_group_stat.impressions.should == 33368 
    ad_group_stat.spent.should == 894 
    ad_group_stat.social_clicks.should == 5 
    ad_group_stat.social_impressions.should == 10561 
    ad_group_stat.social_spent.should == 339 
    ad_group_stat.social_unique_clicks.should == 0 
    ad_group_stat.social_unique_impressions.should == 0 
    ad_group_stat.actions.should == { :like => 1 }
    ad_group_stat.unique_clicks.should ==  0 
    ad_group_stat.unique_impressions.should ==  0
    ad_group_stat.connections.should == 1 
    ad_group_stat.newsfeed_position.should == 2 
  end
end

describe FbGraph::AdGroup, '.fetch' do
  it 'should get the ad group stat with id' do
    mock_graph :get, "6005443999375/stats/0/1348256188", File.join(MOCK_JSON_DIR, 'ad_group_stats/fetch.json'), :access_token => 'valid' do
      stat = FbGraph::AdGroupStat.fetch("6005443999375/stats/0/1348256188", :access_token => 'valid')

      stat.identifier.should == "6005443999375/stats/0/1348256188"
      stat.start_time.should == nil
      stat.end_time.should == Time.parse("2012-09-21T19:36:28+0000") 
      stat.adgroup_id.should == 6005443999375 
      stat.campaign_id.should == 6005443998575 
      stat.clicks.should == 13 
      stat.impressions.should == 33368 
      stat.spent.should == 894 
      stat.social_clicks.should == 5 
      stat.social_impressions.should ==  10561 
      stat.social_spent.should == 339 
      stat.social_unique_clicks.should == 0 
      stat.social_unique_impressions.should == 0 
      stat.actions.should == { "like" => 1 } 
      stat.unique_clicks.should ==  0 
      stat.unique_impressions.should ==  0
      stat.connections.should == 1 
      stat.newsfeed_position.should == nil
    end
  end
end
