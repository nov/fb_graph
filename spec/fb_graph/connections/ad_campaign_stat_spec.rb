require 'spec_helper'

describe FbGraph::Connections::AdCampaignStats, '#ad_campaign_stats' do
  context 'when included by FbGraph::AdAccount' do
    context 'when access_token is given' do
      it 'should return ad_campaign_stats as FbGraph::AdCampaignStat' do
        mock_graph :get, 'act_11223344/adcampaignstats', 'ad_accounts/ad_campaign_stats/test_ad_campaign_stats', :access_token => 'access_token' do
          ad_campaign_stats = FbGraph::AdAccount.new('act_11223344', :access_token => 'access_token').ad_campaign_stats

          ad_campaign_stats.size.should == 2
          ad_campaign_stats.each { |ad_campaign_stat| ad_campaign_stat.should be_instance_of(FbGraph::AdCampaignStat) }
          ad_campaign_stats.first.should == FbGraph::AdCampaignStat.new(
            "6002647797777/stats/0/1315507793",
            :campaign_id => 6002647797777,
            :start_time => nil,
            :end_time => Time.parse("2011-09-08T18:49:53+0000"),
            :impressions => 232641,
            :clicks => 534,
            :spent => 18885,
            :social_impressions => 22676,
            :social_clicks => 81,
            :social_spent => 1548,
            :unique_impressions => 0,
            :social_unique_impressions => 0,
            :unique_clicks => 0,
            :social_unique_clicks => 0,
            :actions => 140,
            :connections => 0,
            :access_token => 'access_token'
          )
        end
      end
    end
  end
end
