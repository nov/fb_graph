require 'spec_helper'

describe FbGraph::Connections::Senders, '#senders' do
  it 'should return senders as FbGraph::User' do
    mock_graph :get, '12345/senders', 'thread/senders/private', :params => {:no_cache => 'true'}, :access_token => 'access_token' do
      senders = FbGraph::Thread.new(12345, :access_token => 'access_token').senders(:no_cache => true)
      senders.each do |sender|
        sender.should be_instance_of(FbGraph::User)
      end
    end
  end

  describe 'cached messages' do
    context 'when cached' do
      let(:thread) { FbGraph::Thread.new(12345, :access_token => 'access_token', :senders => {}) }

      it 'should use cache' do
        lambda do
          thread.senders
        end.should_not request_to '12345/senders?access_token=access_token'
      end

      context 'when options are specified' do
        it 'should not use cache' do
          lambda do
            thread.senders(:no_cache => true)
          end.should request_to '12345/senders?access_token=access_token&no_cache=true'
        end
      end
    end

    context 'otherwise' do
      let(:thread) { FbGraph::Thread.new(12345, :access_token => 'access_token') }

      it 'should not use cache' do
        lambda do
          thread.senders
        end.should request_to '12345/senders?access_token=access_token'
      end
    end
  end
end