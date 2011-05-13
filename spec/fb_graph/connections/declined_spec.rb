require 'spec_helper'

describe FbGraph::Connections::Declined, '#declined' do
  before do
    
  end

  it 'should return declined users as FbGraph::User' do
    mock_graph :get, 'smartday/declined', 'events/declined/smartday_private', :access_token => 'access_token' do
      users = FbGraph::Event.new('smartday', :access_token => 'access_token').declined
      users.each do |user|
        user.should be_instance_of(FbGraph::User)
      end
    end
  end
end

describe FbGraph::Connections::Declined, '#declined!' do
  it 'should return true' do
    mock_graph :post, '12345/declined', 'events/declined/post_with_valid_access_token', :access_token => 'valid' do
      FbGraph::Event.new('12345', :access_token => 'valid').declined!.should be_true
    end
  end
end
