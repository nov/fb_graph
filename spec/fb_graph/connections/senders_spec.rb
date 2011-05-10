require 'spec_helper'

describe FbGraph::Connections::Senders, '#senders' do
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
    mock_graph :get, '12345/senders', 'thread/senders/private', :params => {:no_cache => 'true'}, :access_token => 'access_token' do
      senders = FbGraph::Thread.new(12345, :access_token => 'access_token').senders(:no_cache => true)
      senders.each do |sender|
        sender.should be_instance_of(FbGraph::User)
      end
    end
  end
end