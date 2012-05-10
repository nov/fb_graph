require 'spec_helper'

describe FbGraph::Connections::Invited do
  describe '#invited' do
    it 'should return invited users as FbGraph::User' do
      mock_graph :get, 'smartday/invited', 'events/invited/smartday_private', :access_token => 'access_token' do
        users = FbGraph::Event.new('smartday', :access_token => 'access_token').invited
        users.each do |user|
          user.should be_instance_of(FbGraph::User)
        end
      end
    end
  end

  describe '#invite!' do
    let(:event) { FbGraph::Event.new('smartday', :access_token => 'access_token') }
    it 'should invite a single user to an event' do
      mock_graph :post, 'smartday/invited', 'true', :access_token => 'access_token', :params => {
        :users => "user_id"
      } do
          event.invite!(:users => "user_id").should be_true
      end
    end
  end
end
