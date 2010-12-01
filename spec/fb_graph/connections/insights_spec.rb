require File.join(File.dirname(__FILE__), '../../spec_helper')

describe FbGraph::Connections::Insights, '#insights' do

  context 'when included by FbGraph::Page' do
    before(:all) do
      fake_json(:get, 'FbGraph/insights', 'pages/insights/FbGraph_public')
      fake_json(:get, 'FbGraph/insights?access_token=access_token', 'pages/insights/FbGraph_private')
    end

    context 'when no access_token given' do
      it 'should raise FbGraph::Unauthorized' do
        lambda do
          FbGraph::Page.new('FbGraph').insights
        end.should raise_exception(FbGraph::Unauthorized)
      end
    end

    context 'when access_token is given' do
      it 'should return insights as FbGraph::Insight' do
        insights = FbGraph::Page.new('FbGraph').insights(:access_token => 'access_token')
        insights.class.should == FbGraph::Connection
        insights.first.should == FbGraph::Insight.new(
          '117513961602338/insights/page_fan_adds_unique/day',
          :access_token => 'access_token',
          :name => 'page_fan_adds_unique',
          :description => 'Daily New Likes of your Page (Unique Users)',
          :period => 'day',
          :values => [{
            :value => 1,
            :end_time => '2010-11-27T08:00:00+0000'
          }]
        )
        insights.each do |insight|
          insight.should be_instance_of(FbGraph::Insight)
        end
      end
    end
  end

end
