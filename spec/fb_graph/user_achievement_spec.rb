require 'spec_helper'

describe FbGraph::UserAchievement do
  subject { achievement }
  let(:achievement) { FbGraph::UserAchievement.new(attributes[:id], attributes) }
  let(:attributes) do
    {
      :id => "10150351898227277",
      :from => {
        :id => "10150351898227277",
        :name => "Nov Matake"
      },
      :start_time => "2011-09-27T14:18:33+0000",
      :end_time => "2011-09-27T14:18:33+0000",
      :publish_time => "2011-09-27T14:18:33+0000",
      :application => {
        :id => "134145643294322",
        :name => "gem sample"
      },
      :achievement => {
        :id => "10150310611431721",
        :url => "http:\/\/fbgraphsample.heroku.com\/achievements\/1",
        :type => "game.achievement",
        :title => "1st Achievement"
      },
      :likes => {
        :count => 0
      },
      :comments => {
        :count => 0
      }
    }
  end

  its(:from) { should be_a FbGraph::User }
  its(:achievement) { should be_a FbGraph::Achievement }
  its(:application) { should be_a FbGraph::Application }
  its(:created_time) { should == Time.parse(attributes[:publish_time]).utc }

  describe '#destroy' do
    it 'should call DELETE /:app_id/achievements' do
      expect { achievement.destroy }.to request_to('10150351898227277/achievements', :delete)
    end

    it 'should delete achievement' do
      mock_graph :delete, '10150351898227277/achievements', 'true', :access_token => 'app_token', :params => {
        :achievement => achievement.achievement.url
      } do
        achievement.destroy(:access_token => 'app_token').should be_true
      end
    end
  end
end