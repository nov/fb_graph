require 'spec_helper'

describe FbGraph::Connections::AdGroupStats, '#adgroupstats' do
  context 'when included by FbGraph::AdAccount' do
    context 'when access_token is given' do
      it 'should return ad_group_stats as FbGraph::AdGroupStat' do
        mock_graph :get, 'act_11223344/adgroupstats', 'ad_accounts/ad_group_stats/test_ad_group_stats', :access_token => 'access_token' do
          ad_group_stats = FbGraph::AdAccount.new('act_11223344', :access_token => 'access_token').adgroupstats

          ad_group_stats.size.should == 3
          ad_group_stats.total_count.should == 3081
          ad_group_stats.each { |ad_group_stat| ad_group_stat.should be_instance_of(FbGraph::AdGroupStat) }
          ad_group_stats.first.should == FbGraph::AdGroupStat.new(
            "6002647798444/stats/0/1315607403",
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
            :adgroup_id => 6002647798444,
            :start_time => nil,
            :end_time => "2011-09-09T22:30:03+0000",
            :access_token => "access_token"
          )
        end
      end
    end
  end
end

