require 'spec_helper'

describe FbGraph::Connections::Invited, '#invited' do
  it 'should return invited users as FbGraph::User' do
    mock_graph :get, 'smartday/invited', 'events/invited/smartday_private', :access_token => 'access_token' do
      users = FbGraph::Event.new('smartday', :access_token => 'access_token').invited
      users.each do |user|
        user.should be_instance_of(FbGraph::User)
      end
    end
  end
end