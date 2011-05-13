require 'spec_helper'

describe FbGraph::Connections::FormerParticipants, '#former_participants' do
  it 'should use cached contents as default' do
    lambda do
      FbGraph::Thread.new(12345, :access_token => 'access_token').former_participants
    end.should_not request_to '12345/former_participants?access_token=access_token'
  end

  it 'should not use cached contents when options are specified' do
    lambda do
      FbGraph::Thread.new(12345).former_participants(:no_cache => true)
    end.should request_to '12345/former_participants?no_cache=true'
  end

  it 'should return former_participants as FbGraph::User' do
    mock_graph :get, '12345/former_participants', 'thread/former_participants/private', :access_token => 'access_token', :params => {
      :no_cache => 'true'
    } do
      former_participants = FbGraph::Thread.new(12345, :access_token => 'access_token').former_participants(:no_cache => true)
      former_participants.each do |former_participant|
        former_participant.should be_instance_of(FbGraph::User)
      end
    end
  end
end