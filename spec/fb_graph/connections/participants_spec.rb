require 'spec_helper'

describe FbGraph::Connections::Participants, '#participants' do
  it 'should use cached contents as default' do
    lambda do
      FbGraph::Thread.new(12345, :access_token => 'access_token').participants
    end.should_not request_to '12345/participants?access_token=access_token'
  end

  it 'should not use cached contents when options are specified' do
    lambda do
      FbGraph::Thread.new(12345).participants(:no_cache => true)
    end.should request_to '12345/participants?no_cache=true'
  end

  it 'should return participants as FbGraph::User' do
    mock_graph :get, '12345/participants', 'thread/participants/private', :params => {:no_cache => 'true'}, :access_token => 'access_token' do
      participants = FbGraph::Thread.new(12345, :access_token => 'access_token').participants(:no_cache => true)
      participants.each do |participant|
        participant.should be_instance_of(FbGraph::User)
      end
    end
  end
end