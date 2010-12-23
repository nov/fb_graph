require File.join(File.dirname(__FILE__), '../../spec_helper')

describe FbGraph::Connections::Noreply, '#noreply' do
  before do
    fake_json(:get, 'smartday/noreply?access_token=access_token', 'events/noreply/smartday_private')
  end

  it 'should return noreply users as FbGraph::User' do
    users = FbGraph::Event.new('smartday', :access_token => 'access_token').noreply
    users.each do |user|
      user.should be_instance_of(FbGraph::User)
    end
  end
end