require 'spec_helper'

describe FbGraph::Connections::Insights do
  describe '#insights' do
    context 'when included by FbGraph::Page' do
      context 'when no access_token given' do
        it 'should raise FbGraph::Unauthorized' do
          mock_graph :get, 'FbGraph/insights', 'pages/insights/FbGraph_public', :status => [401, 'Unauthorized'] do
            lambda do
              FbGraph::Page.new('FbGraph').insights
            end.should raise_exception(FbGraph::Unauthorized)
          end
        end
      end

      context 'when access_token is given' do
        it 'should return insights as FbGraph::Insight' do
          mock_graph :get, 'FbGraph/insights', 'pages/insights/FbGraph_private', :access_token => 'access_token' do
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

      context 'when metrics is given' do
        it 'should treat metrics as connection scope' do
          mock_graph :get, 'FbGraph/insights/page_like_adds', 'pages/insights/page_like_adds/FbGraph_private', :access_token => 'access_token' do
            insights = FbGraph::Page.new('FbGraph').insights(:access_token => 'access_token', :metrics => :page_like_adds)
            insights.options.should == {
              :connection_scope => 'page_like_adds',
              :access_token => 'access_token'
            }
            insights.first.should == FbGraph::Insight.new(
              '117513961602338/insights/page_like_adds/day',
              :access_token => 'access_token',
              :name => 'page_like_adds',
              :description => 'Daily Likes of your Page\'s content (Total Count)',
              :period => 'day',
              :values => [{
                :value => 0,
                :end_time => '2010-12-09T08:00:00+0000'
              }, {
                :value => 0,
                :end_time => '2010-12-10T08:00:00+0000'
              }, {
                :value => 0,
                :end_time => '2010-12-11T08:00:00+0000'
              }]
            )
          end
        end

        it 'should support period also' do
          mock_graph :get, 'FbGraph/insights/page_like_adds/day', 'pages/insights/page_like_adds/day/FbGraph_private', :access_token => 'access_token' do
            insights = FbGraph::Page.new('FbGraph').insights(:access_token => 'access_token', :metrics => :page_like_adds, :period => :day)
            insights.options.should == {
              :connection_scope => 'page_like_adds/day',
              :access_token => 'access_token'
            }
            insights.first.should == FbGraph::Insight.new(
              '117513961602338/insights/page_like_adds/day',
              :access_token => 'access_token',
              :name => 'page_like_adds',
              :description => 'Daily Likes of your Page\'s content (Total Count)',
              :period => 'day',
              :values => [{
                :value => 1,
                :end_time => '2010-12-09T08:00:00+0000'
              }, {
                :value => 1,
                :end_time => '2010-12-10T08:00:00+0000'
              }, {
                :value => 1,
                :end_time => '2010-12-11T08:00:00+0000'
              }]
            )
          end
        end

        it 'should used for pagination' do
          mock_graph :get, 'FbGraph/insights/page_like_adds/day', 'pages/insights/page_like_adds/day/FbGraph_private', :access_token => 'access_token' do
            insights = FbGraph::Page.new('FbGraph').insights(:access_token => 'access_token', :metrics => :page_like_adds, :period => :day)
            expect { insights.next }.to request_to 'FbGraph/insights/page_like_adds/day?access_token=134145643294322%7C9b95ab3141be69aff9766c90-579612276%7C9UA_-V98QdZDfoX4MSS-DdwTFFk&since=1292065709&until=1292324909'
            expect { insights.previous }.to request_to 'FbGraph/insights/page_like_adds/day?access_token=134145643294322%7C9b95ab3141be69aff9766c90-579612276%7C9UA_-V98QdZDfoX4MSS-DdwTFFk&since=1291547309&until=1291806509'
          end
        end
      end
    end
  end
end
