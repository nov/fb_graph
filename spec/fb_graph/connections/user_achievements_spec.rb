require 'spec_helper'

describe FbGraph::Connections::UserAchievements do
  let(:user) { FbGraph::User.new('matake', :access_token => 'access_token') }

  describe '#achievements' do
    it 'should return an Array of FbGraph::UserAchievement' do
      mock_graph :get, 'matake/achievements', 'users/user_achievements/sample', :access_token => 'access_token' do
        user.achievements.each do |achievement|
          achievement.should be_instance_of FbGraph::UserAchievement
        end
      end
    end
  end

  describe '#achieve!' do
    let(:achievement_url) { 'http://fbgraphsample.heroku.com/achievements/1' }
    it 'should return FbGraph::UserAchievement' do
      mock_graph :post, 'matake/achievements', 'users/user_achievements/created', :access_token => 'access_token', :params => {
        :achievement => achievement_url
      } do
        user.achieve!(achievement_url).should be_instance_of FbGraph::UserAchievement
      end
    end
  end

  describe '#unachieve!' do
    let(:achievement_url) { 'http://fbgraphsample.heroku.com/achievements/1' }
    it 'should return true' do
      mock_graph :delete, 'matake/achievements', 'true', :access_token => 'access_token', :params => {
        :achievement => achievement_url
      } do
        user.unachieve!(achievement_url).should be_true
      end
    end
  end
end