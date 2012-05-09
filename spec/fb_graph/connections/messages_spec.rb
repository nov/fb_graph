require 'spec_helper'

describe FbGraph::Connections::Messages do
  describe '#messages' do
    it 'should return threads as FbGraph::Message' do
      mock_graph :get, '12345/messages', 'thread/messages/private', :params => {:no_cache => 'true'}, :access_token => 'access_token' do
        messages = FbGraph::Thread.new(12345, :access_token => 'access_token').messages(:no_cache => true)
        messages.each do |message|
          message.should be_instance_of(FbGraph::Message)
        end
      end
    end

    describe 'cached messages' do
      context 'when cached' do
        let(:thread) { FbGraph::Thread.new(12345, :access_token => 'access_token', :messages => {}) }

        it 'should use cache' do
          lambda do
            thread.messages
          end.should_not request_to '12345/messages?access_token=access_token'
        end

        context 'when options are specified' do
          it 'should not use cache' do
            lambda do
              thread.messages(:no_cache => true)
            end.should request_to '12345/messages?access_token=access_token&no_cache=true'
          end
        end
      end

      context 'otherwise' do
        let(:thread) { FbGraph::Thread.new(12345, :access_token => 'access_token') }

        it 'should not use cache' do
          lambda do
            thread.messages
          end.should request_to '12345/messages?access_token=access_token'
        end
      end
    end
  end

  describe '#message!' do
    let(:thread) { FbGraph::Thread.new(12345, :access_token => 'access_token') }

    it 'should return FbGraph::Message' do
      mock_graph :post, '12345/messages', 'thread/messages/created', :access_token => 'access_token', :params => {
        :message => 'Hello'
      } do
        message = thread.message! 'Hello'
        message.should be_instance_of FbGraph::Message
        message.message.should == 'Hello'
      end
    end
  end
end