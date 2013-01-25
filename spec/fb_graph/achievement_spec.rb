require 'spec_helper'

describe FbGraph::Achievement do
  subject { achievement }
  let(:achievement) { FbGraph::Achievement.new(attributes[:id], attributes) }
  let(:attributes) do
    {
      :id => "10150310611431721",
      :url => "http:\/\/fbgraphsample.heroku.com\/achievements\/1",
      :type => "game.achievement",
      :title => "1st Achievement",
      :image => [{
        :url => "http:\/\/matake.jp\/images\/nov.gif"
      }],
      :description => "For testing purpose",
      :data => {
        :points => 50
      },
      :updated_time => "2011-09-27T08:06:59+0000",
      :application => {
        :id => "134145643294322",
        :name => "gem sample",
        :url => "http:\/\/www.facebook.com\/apps\/application.php?id=134145643294322"
      },
      :context => {
        :display_order => 0
      }
    }
  end

  [:type, :title, :url, :description, :data, :context].each do |key|
    its(key) { should == attributes[key] }
  end

  its(:image) { should == attributes[:image].first[:url] }
  its(:images) { should == attributes[:image].collect { |h| h[:url] } }
  its(:points) { should == 50 }
  its(:display_order) { should == 0 }
  its(:updated_time) { should == Time.parse(attributes[:updated_time]).utc }
  describe 'application' do
    subject { achievement.application }
    its(:name) { should == attributes[:application][:name] }
    its(:link) { should == attributes[:application][:url] }
  end

  describe '#destroy' do
    it 'should call DELETE /:app_id/achievements' do
      expect { achievement.destroy }.to request_to('134145643294322/achievements', :delete)
    end

    it 'should delete achievement' do
      mock_graph :delete, '134145643294322/achievements', 'true', :access_token => 'app_token', :params => {
        :achievement => achievement.url
      } do
        achievement.destroy(:access_token => 'app_token').should be_true
      end
    end
  end
end