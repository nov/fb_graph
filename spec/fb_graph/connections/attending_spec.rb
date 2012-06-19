require 'spec_helper'

describe FbGraph::Connections::Attending do
  let(:event) do
    FbGraph::Event.new('smartday', :access_token => 'access_token')
  end

  describe '#attending' do
    it 'should return attending users as FbGraph::User' do
      mock_graph :get, 'smartday/attending', 'events/attending/smartday_private', :access_token => 'access_token' do
        event.attending.each do |user|
          user.should be_instance_of(FbGraph::User)
        end
      end
    end
  end

  describe '#attending?' do
    context 'when attending' do
      it 'should return true' do
        mock_graph :get, 'smartday/attending/uid', 'events/invited/attending', :access_token => 'access_token' do
          event.attending?(
            FbGraph::User.new('uid')
          ).should be_true
        end
      end
    end

    context 'otherwise' do
      it 'should return false' do
        mock_graph :get, 'smartday/attending/uid', 'empty', :access_token => 'access_token' do
          event.attending?(
            FbGraph::User.new('uid')
          ).should be_false
        end
      end
    end
  end

  describe '#attend!' do
    it 'should return true' do
      mock_graph :post, 'smartday/attending', 'events/attending/post_with_valid_access_token', :access_token => 'access_token' do
        event.attend!.should be_true
      end
    end
  end
end
