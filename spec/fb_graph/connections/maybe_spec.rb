require File.join(File.dirname(__FILE__), '../../spec_helper')

describe FbGraph::Connections::Maybe, '#maybe' do
  before do
    fake_json(:get, 'smartday/maybe?access_token=access_token', 'events/maybe/smartday_private')
  end

  it 'should return maybe users as FbGraph::User' do
    users = FbGraph::Event.new('smartday', :access_token => 'access_token').maybe
    users.each do |user|
      user.should be_instance_of(FbGraph::User)
    end
  end
end

describe FbGraph::Connections::Maybe, '#maybe!' do
  before do
    fake_json(:post, '12345/maybe', 'events/maybe/post_with_valid_access_token')
  end

  it 'should return true' do
    FbGraph::Event.new('12345', :access_token => 'valid').maybe!.should be_true
  end
end
