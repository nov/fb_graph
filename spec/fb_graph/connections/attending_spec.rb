require File.join(File.dirname(__FILE__), '../../spec_helper')

describe FbGraph::Connections::Attending, '#attending' do
  before(:all) do
    fake_json(:get, 'smartday/attending?access_token=access_token', 'events/attending/smartday_private')
  end

  it 'should return attending users as FbGraph::User' do
    users = FbGraph::Event.new('smartday', :access_token => 'access_token').attending
    users.each do |user|
      user.should be_instance_of(FbGraph::User)
    end
  end
end

describe FbGraph::Connections::Attending, '#attending!' do
  before do
    fake_json(:post, '12345/attending', 'events/attending/post_with_valid_access_token')
  end

  it 'should return true' do
    FbGraph::Event.new('12345', :access_token => 'valid').attending!.should be_true
  end
end
