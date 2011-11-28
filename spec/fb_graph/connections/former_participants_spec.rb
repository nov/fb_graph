require 'spec_helper'

describe FbGraph::Connections::FormerParticipants, '#former_participants' do
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

  describe 'cached messages' do
    context 'when cached' do
      let(:thread) { FbGraph::Thread.new(12345, :access_token => 'access_token', :former_participants => {}) }

      it 'should use cache' do
        lambda do
          thread.former_participants
        end.should_not request_to '12345/former_participants?access_token=access_token'
      end

      context 'when options are specified' do
        it 'should not use cache' do
          lambda do
            thread.former_participants(:no_cache => true)
          end.should request_to '12345/former_participants?access_token=access_token&no_cache=true'
        end
      end
    end

    context 'otherwise' do
      let(:thread) { FbGraph::Thread.new(12345, :access_token => 'access_token') }

      it 'should not use cache' do
        lambda do
          thread.former_participants
        end.should request_to '12345/former_participants?access_token=access_token'
      end
    end
  end
end