require 'spec_helper'

describe FbGraph::Connections::AdGroupConversionStats, '#ad_group_conversion_stats' do
  context 'when included by FbGraph::AdAccount' do
    context 'when access_token is given' do
      it 'should return ad_group_conversions as FbGraph::AdGroupConversionStat' do
        mock_graph :get, 'act_11223344/adgroupconversions', 'ad_accounts/ad_group_conversion_stats/adgroupconversions', :access_token => 'valid' do
          ad_group_conversions = FbGraph::AdAccount.new('act_11223344', :access_token => 'valid').ad_group_conversions

          ad_group_conversions.size.should == 3
          ad_group_conversions.total_count.should == 2105
          ad_group_conversions.each { |ad_group_conversion_stat| ad_group_conversion_stat.should be_instance_of(FbGraph::AdGroupConversionStat) }
          ad_group_conversions.first.adgroup_id.should ==  6004070502180
        end
      end
    end
  end
end
