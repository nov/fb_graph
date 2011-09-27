require 'spec_helper'

describe FbGraph::Connections::Achievements do
  let(:app) { FbGraph::Application.new('app_id', :access_token => 'app_token') }

  describe '#achievements' do
    it 'should return an Array of FbGraph::Achievement' do
      mock_graph :get, 'app_id/achievements', 'applications/achievements/sample', :access_token => 'app_token' do
        app.achievements.each do |achievement|
          achievement.should be_instance_of FbGraph::Achievement
        end
      end
    end
  end
end