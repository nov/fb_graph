require 'spec_helper'

describe FbGraph::Connections::AdGroups, '#ad_groups' do
  context 'when included by FbGraph::AdCampaign' do
    context 'when access_token is given' do
      it 'should return ad_groups as FbGraph::AdGroup' do
        mock_graph :get, '22334455/adgroups', 'ad_campaigns/ad_groups/22334455_ad_groups', :access_token => 'access_token' do
          ad_groups = FbGraph::AdCampaign.new('22334455', :access_token => 'access_token').ad_groups
          ad_groups.first.should == FbGraph::AdGroup.new(
            44556677,
            :access_token => 'access_token',
            :ad_id => 44556677,
            :campaign_id => 22334455,
            :name => "Test Ad Group 1",
            :adgroup_status => 1,
            :bid_type => 1,
            :max_bid => 150,
            :adgroup_id => 44556677,
            :end_time => Time.parse("2011-09-01T00:00:00+00:00"),
            :start_time => Time.parse("2011-09-10T00:00:00+00:00"),
            :updated_time => Time.parse("2011-09-05T00:00:00+00:00")
          )
          ad_groups.each { |ad_group| ad_group.should be_instance_of(FbGraph::AdGroup) }
        end
      end
    end
  end
end

describe FbGraph::Connections::AdGroups, '#ad_group!' do
  context 'when included by FbGraph::AdAccount' do
    it 'should return generated ad_group' do
      mock_graph :post, 'act_22334455/adgroups', 'ad_accounts/ad_groups/post_with_valid_access_token' do
        ad_group = FbGraph::AdAccount.new('act_22334455', :access_token => 'valid').ad_group!(
          :name => "Test Ad 1",
          :campaign_id => 66778899,
          :bid_type => 1,
          :max_bid => 100,
          :start_time => Time.parse("2011-09-10T12:00:00+00:00"),
          :end_time => Time.parse("2011-09-20T16:00:00-04:00")
        )

        ad_group.identifier.should == 112233445566
        ad_group.campaign_id.should == 66778899
        ad_group.name.should == "Test Ad 1"
        ad_group.bid_type.should == 1
        ad_group.max_bid.should == 100
        ad_group.start_time.should == Time.parse("2011-09-10T12:00:00+00:00")
        ad_group.end_time.should == Time.parse("2011-09-20T16:00:00-04:00")
      end
    end
  end
end

