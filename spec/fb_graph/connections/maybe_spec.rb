require 'spec_helper'

describe FbGraph::Connections::Maybe do
  let(:event) do
    FbGraph::Event.new('smartday', :access_token => 'access_token')
  end

  describe '#maybe' do
    it 'should return maybe users as FbGraph::User' do
      mock_graph :get, 'smartday/maybe', 'events/maybe/smartday_private', :access_token => 'access_token' do
        event.maybe.each do |user|
          user.should be_instance_of(FbGraph::User)
        end
      end
    end
  end

  describe '#maybe?' do
    context 'when maybe' do
      it 'should return true' do
        mock_graph :get, 'smartday/maybe/uid', 'events/invited/unsure', :access_token => 'access_token' do
          event.maybe?(
            FbGraph::User.new('uid')
          ).should be_true
        end
      end
    end

    context 'otherwise' do
      it 'should return false' do
        mock_graph :get, 'smartday/maybe/uid', 'empty', :access_token => 'access_token' do
          event.maybe?(
            FbGraph::User.new('uid')
          ).should be_false
        end
      end
    end
  end

  describe '#maybe!' do
    it 'should return true' do
      mock_graph :post, 'smartday/maybe', 'events/maybe/post_with_valid_access_token' do
        event.maybe!.should be_true
      end
    end
  end
end
