require 'spec_helper'

describe FbGraph::Connections::Attending, '#attending' do
  it 'should return attending users as FbGraph::User' do
    mock_graph :get, 'smartday/attending', 'events/attending/smartday_private', :access_token => 'access_token' do
      users = FbGraph::Event.new('smartday', :access_token => 'access_token').attending
      users.each do |user|
        user.should be_instance_of(FbGraph::User)
      end
    end
  end
end

describe FbGraph::Connections::Attending, '#attending!' do
  it 'should return true' do
    mock_graph :post, '12345/attending', 'events/attending/post_with_valid_access_token', :access_token => 'valid' do
      FbGraph::Event.new('12345', :access_token => 'valid').attending!.should be_true
    end
  end
end
