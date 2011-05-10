require 'spec_helper'

describe FbGraph::Connections::Messages, '#messages' do
  it 'should use cached contents as default' do
    lambda do
      FbGraph::Thread.new(12345, :access_token => 'access_token').messages
    end.should_not request_to '12345/messages?access_token=access_token'
  end

  it 'should not use cached contents when options are specified' do
    lambda do
      FbGraph::Thread.new(12345).messages(:no_cache => true)
    end.should request_to '12345/messages?no_cache=true'
  end

  it 'should return threads as FbGraph::Message' do
    mock_graph :get, '12345/messages', 'thread/messages/private', :params => {:no_cache => 'true'}, :access_token => 'access_token' do
      messages = FbGraph::Thread.new(12345, :access_token => 'access_token').messages(:no_cache => true)
      messages.each do |message|
        message.should be_instance_of(FbGraph::Message)
      end
    end
  end
end