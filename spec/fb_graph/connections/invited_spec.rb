require 'spec_helper'

describe FbGraph::Connections::Invited do
  let(:event) { FbGraph::Event.new('smartday', :access_token => 'access_token') }

  describe '#invited' do
    it 'should return invited users as FbGraph::User' do
      mock_graph :get, 'smartday/invited', 'events/invited/smartday_private', :access_token => 'access_token' do
        event.invited.each do |user|
          user.should be_instance_of(FbGraph::User)
        end
      end
    end
  end

  describe '#invited?' do
    context 'when invited' do
      it 'should return RSVP status' do
        mock_graph :get, 'smartday/invited/1575327134', 'events/invited/not_replied', :access_token => 'access_token' do
          event.invited?(
            FbGraph::User.new('1575327134')
          ).should == :not_replied
        end
      end
    end

    context 'otherwise' do
      it 'should return false' do
        mock_graph :get, 'smartday/invited/12345', 'empty', :access_token => 'access_token' do
          event.invited?(
            FbGraph::User.new('12345')
          ).should be_false
        end
      end
    end 
  end

  describe '#invite!' do
    context 'when options[:users] option is given' do
      it 'should use it' do
        mock_graph :post, 'smartday/invited', 'true', :access_token => 'access_token', :params => {
          :users => "uid1,uid2"
        } do
          event.invite!(:users => "uid1,uid2").should be_true
        end
      end
    end

    context 'otherwise' do
      context 'when single user is given' do
        it 'should invite him/her' do
          mock_graph :post, 'smartday/invited', 'true', :access_token => 'access_token', :params => {
            :users => "uid1"
          } do
            event.invite!(
              FbGraph::User.new("uid1")
            ).should be_true
          end
        end
      end

      context 'when an Array of users are given' do
        it 'should invite all of them' do
          mock_graph :post, 'smartday/invited', 'true', :access_token => 'access_token', :params => {
            :users => "uid1,uid2"
          } do
            event.invite!(
              FbGraph::User.new("uid1"),
              FbGraph::User.new("uid2")
            ).should be_true
          end
        end
      end
    end
  end

  describe '#uninvite!' do
    it 'should return true' do
      mock_graph :delete, 'smartday/invited/uid', 'true', :access_token => 'access_token' do
        event.uninvite!(FbGraph::User.new("uid")).should be_true
      end
    end
  end
end
