require 'spec_helper'

describe FbGraph::OpenGraph::Action do
  subject do
    FbGraph::OpenGraph::Action.new attributes[:id], attributes
  end
  let :attributes do
    MultiJson.load(json).with_indifferent_access
  end
  shared_examples_for :og_action_initialized do
    its(:from) do
      should == FbGraph::User.new(attributes[:from][:id], attributes[:from])
    end
    its(:application) do
      should == FbGraph::Application.new(attributes[:application][:id], attributes[:application])
    end
    [:start_time, :end_time, :publish_time].each do |key|
      its(key) { should == Time.parse(attributes[key]) }
    end
    its(:objects) { should be_a Hash }
    its(:likes) { should be_instance_of FbGraph::Connection }
    its(:comments) { should be_instance_of FbGraph::Connection }
  end

  context 'with play action' do
    let :json do
      <<-JSON
        {
          "id": "10150402047187277",
          "from": {
            "id": "579612276",
            "name": "Nov Matake"
          },
          "start_time": "2011-11-05T00:19:01+0000",
          "end_time": "2011-11-05T00:19:01+0000",
          "publish_time": "2011-11-05T00:19:01+0000",
          "application": {
            "id": "134145643294322",
            "name": "gem sample"
          },
          "data": {
            "game": {
              "id": "10150267719331290",
              "url": "http:\/\/samples.ogp.me\/163382137069945",
              "type": "game",
              "title": "Sample Game"
            }
          },
          "likes": {
            "count": 0
          },
          "comments": {
            "count": 0
          },
          "type": "games.plays"
        }
      JSON
    end
    it_behaves_like :og_action_initialized
    its(:type) { should == 'games.plays' }
    it 'should have a game object' do
      subject.objects['game'].should == subject.objects[:game]
      subject.objects[:game].should be_instance_of FbGraph::OpenGraph::Object
      subject.objects[:game].type.should == 'game'
    end
  end

  context 'with custom action' do
    let :json do
      <<-JSON
        {
          "id": "10150389446227277",
          "from": {
            "id": "579612276",
            "name": "Nov Matake"
          },
          "start_time": "2011-10-26T02:21:00+0000",
          "end_time": "2011-10-26T02:21:00+0000",
          "publish_time": "2011-10-26T02:21:00+0000",
          "application": {
            "id": "134145643294322",
            "name": "gem sample"
          },
          "data": {
            "custom_field": "This is not a JSON object.",
            "custom_object": {
              "id": "10150362170052970",
              "url": "http:\/\/samples.ogp.me\/264755040233381",
              "type": "fbgraphsample:custom_object",
              "title": "Custom Object"
            }
          },
          "likes": {
            "count": 0
          },
          "comments": {
            "count": 0
          },
          "type": "fbgraphsample:custom_action"
        }
      JSON
    end
    it_behaves_like :og_action_initialized
    its(:type) { should == 'fbgraphsample:custom_action' }
    it 'should have a custom object' do
      subject.objects['custom_object'].should == subject.objects[:custom_object]
      subject.objects[:custom_object].should be_instance_of FbGraph::OpenGraph::Object
      subject.objects[:custom_object].type.should == 'fbgraphsample:custom_object'
      subject.objects[:custom_field].should == 'This is not a JSON object.'
    end
  end
end