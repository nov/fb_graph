require 'spec_helper'

describe FbGraph::Connections::Declined, '#declined' do
  before do
    fake_json(:get, 'smartday/declined?access_token=access_token', 'events/declined/smartday_private')
  end

  it 'should return declined users as FbGraph::User' do
    users = FbGraph::Event.new('smartday', :access_token => 'access_token').declined
    users.each do |user|
      user.should be_instance_of(FbGraph::User)
    end
  end
end

describe FbGraph::Connections::Declined, '#declined!' do
  before do
    fake_json(:post, '12345/declined', 'events/declined/post_with_valid_access_token')
  end

  it 'should return true' do
    FbGraph::Event.new('12345', :access_token => 'valid').declined!.should be_true
  end
end
