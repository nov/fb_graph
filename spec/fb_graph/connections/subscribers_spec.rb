require 'spec_helper'

describe FbGraph::Connections::Subscribers do
  it 'should return subscribers as FbGraph::User' do
    mock_graph :get, 'me/subscribers', 'users/subscribers/sample', :access_token => 'access_token' do
      subscribers = FbGraph::User.me('access_token').subscribers
      subscribers.each do |subscriber|
        subscriber.should be_instance_of FbGraph::User
      end
    end
  end
end