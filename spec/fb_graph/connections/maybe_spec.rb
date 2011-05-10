require 'spec_helper'

describe FbGraph::Connections::Maybe, '#maybe' do
  it 'should return maybe users as FbGraph::User' do
    mock_graph :get, 'smartday/maybe', 'events/maybe/smartday_private', :access_token => 'access_token' do
      users = FbGraph::Event.new('smartday', :access_token => 'access_token').maybe
      users.each do |user|
        user.should be_instance_of(FbGraph::User)
      end
    end
  end
end

describe FbGraph::Connections::Maybe, '#maybe!' do
  it 'should return true' do
    mock_graph :post, '12345/maybe', 'events/maybe/post_with_valid_access_token' do
      FbGraph::Event.new('12345', :access_token => 'valid').maybe!.should be_true
    end
  end
end
