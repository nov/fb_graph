require 'spec_helper'

describe FbGraph::Connections::Achievements do
  let(:app) { FbGraph::Application.new('app_id', :access_token => 'app_token') }

  describe '#achievements' do
    it 'should return an Array of FbGraph::Achievement' do
      mock_graph :get, 'app_id/achievements', 'applications/achievements/sample', :access_token => 'app_token' do
        app.achievements.each do |achievement|
          achievement.should be_instance_of FbGraph::Achievement
          achievement.access_token.should == 'app_token'
        end
      end
    end
  end

  describe '#achievement!' do
    let(:achievement_url) { 'http://fbgraphsample.heroku.com/achievements/1' }
    it 'should return true' do
      mock_graph :post, 'app_id/achievements', 'true', :access_token => 'app_token', :params => {
        :achievement => achievement_url
      } do
        app.achievement!(achievement_url).should be_true
      end
    end
  end
end