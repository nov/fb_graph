require File.join(File.dirname(__FILE__), '../../spec_helper')

describe FbGraph::Connections::Senders, '#senders' do
  before do
    fake_json(:get, '12345/senders?access_token=access_token&no_cache=true', 'thread/senders/private')
  end

  it 'should use cached contents as default' do
    lambda do
      FbGraph::Thread.new(12345, :access_token => 'access_token').senders
    end.should_not request_to '12345/senders?access_token=access_token'
  end

  it 'should not use cached contents when options are specified' do
    lambda do
      FbGraph::Thread.new(12345).senders(:no_cache => true)
    end.should request_to '12345/senders?no_cache=true'
  end

  it 'should return senders as FbGraph::User' do
    senders = FbGraph::Thread.new(12345, :access_token => 'access_token').senders(:no_cache => true)
    senders.each do |sender|
      sender.should be_instance_of(FbGraph::User)
    end
  end
end