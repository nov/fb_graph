require 'spec_helper'

describe FbGraph::Connections::AppInsights do
  describe '#insights' do
    context 'when included by FbGraph::Application' do
      context 'when no access_token given' do
        it 'should raise FbGraph::Unauthorized' do
          mock_graph :get, 'FbGraph/app_insights/metric', 'applications/app_insights/FbGraph_public', :status => [401, 'Unauthorized'] do
            lambda do
              FbGraph::Application.new('FbGraph').app_insights('metric')
            end.should raise_exception(FbGraph::Unauthorized)
          end
        end
      end

      context 'when access_token is given' do
        it 'should return app_insights as FbGraph::AppInsight' do
          mock_graph :get, 'FbGraph/app_insights/metric', 'applications/app_insights/FbGraph_private', :access_token => 'access_token' do
            insights = FbGraph::Application.new('FbGraph').app_insights('metric', :access_token => 'access_token')
            insights.class.should == FbGraph::Connection
            insights.first.should == FbGraph::AppInsight.new(
              :time  => '2014-12-18T08:00:00+0000',
              :value => '0'
            )
            insights.each do |insight|
              insight.should be_instance_of(FbGraph::AppInsight)
            end
          end
        end
      end
    end
  end
end
