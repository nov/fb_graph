require 'spec_helper'

describe FbGraph::Connections::Noreply, '#noreply' do
  it 'should return noreply users as FbGraph::User' do
    mock_graph :get, 'smartday/noreply', 'events/noreply/smartday_private', :access_token => 'access_token' do
      users = FbGraph::Event.new('smartday', :access_token => 'access_token').noreply
      users.each do |user|
        user.should be_instance_of(FbGraph::User)
      end
    end
  end
end