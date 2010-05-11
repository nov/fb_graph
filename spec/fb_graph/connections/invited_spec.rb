require File.join(File.dirname(__FILE__), '../../spec_helper')

describe FbGraph::Connections::Invited, '#invited' do
  before(:all) do
    fake_json(:get, 'smartday/invited?access_token=access_token', 'events/invited/smartday_private')
  end

  it 'should return invited users as FbGraph::User' do
    users = FbGraph::Event.new('smartday', :access_token => 'access_token').invited
    users.each do |user|
      user.should be_instance_of(FbGraph::User)
    end
  end
end