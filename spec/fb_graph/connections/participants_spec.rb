require 'spec_helper'

describe FbGraph::Connections::Participants, '#participants' do
  before do
    fake_json(:get, '12345/participants?access_token=access_token&no_cache=true', 'thread/participants/private')
  end

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
    participants = FbGraph::Thread.new(12345, :access_token => 'access_token').participants(:no_cache => true)
    participants.each do |participant|
      participant.should be_instance_of(FbGraph::User)
    end
  end
end