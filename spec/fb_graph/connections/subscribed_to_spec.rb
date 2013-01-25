require 'spec_helper'

describe FbGraph::Connections::SubscribedTo do
  it 'should return subscribees as FbGraph::User' do
    mock_graph :get, 'me/subscribedto', 'users/subscribed_to/sample', :access_token => 'access_token' do
      subscribees = FbGraph::User.me('access_token').subscribed_to
      subscribees.each do |subscribee|
        subscribee.should be_instance_of FbGraph::User
      end
    end
  end
end