require 'spec_helper'

describe FbGraph::AdGroupConversionStat, '.new' do
  it 'should setup all supported attributes' do
    attributes = {
      :adgroup_id =>  6004070829980, 
      :values => [{
        :conversions => [
            {
                :action_type => "comment", 
                :object_id  => 410401442331394, 
                :post_click_1d => 0, 
                :post_click_28d => 0, 
                :post_click_7d => 0, 
                :post_imp_1d => 0, 
                :post_imp_28d => 1, 
                :post_imp_7d => 0
            }, 
            {
                :action_type => "like", 
                :object_id => 410401442331394, 
                :post_click_1d => 0, 
                :post_click_28d => 0, 
                :post_click_7d => 0, 
                :post_imp_1d => 0, 
                :post_imp_28d => 1, 
                :post_imp_7d => 1
            }, 
            {
                :action_type => "link_click", 
                :object_id => 410401442331394, 
                :post_click_1d => 0, 
                :post_click_28d => 0, 
                :post_click_7d => 0, 
                :post_imp_1d => 0, 
                :post_imp_28d => 1, 
                :post_imp_7d => 1
            }
        ], 
        :end_time => 1348545600, 
        :start_time => 18000
      }]
    }

    ad_group_conversion_stat = FbGraph::AdGroupConversionStat.new(attributes.delete(:id), attributes)
    ad_group_conversion_stat.identifier.should == nil
    ad_group_conversion_stat.adgroup_id.should == 6004070829980 
    ad_group_conversion_stat.values.first[:conversions][0][:action_type] == "comment"
    ad_group_conversion_stat.values.first[:conversions][1][:action_type] == "like"
    ad_group_conversion_stat.values.first[:conversions][2][:action_type] == "link_click"
    ad_group_conversion_stat.values.first[:start_time] = 18000
    ad_group_conversion_stat.values.first[:end_time] = 1348545600
  end
end
