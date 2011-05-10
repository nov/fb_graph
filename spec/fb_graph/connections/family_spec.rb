require 'spec_helper'

describe FbGraph::Connections::Family, '#family' do
  context 'when included by FbGraph::User' do
    context 'when no access_token given' do
      it 'should raise FbGraph::Unauthorized' do
        mock_graph :get, 'me/family', 'users/family/family_without_access_token', :status => [401, 'Unauthorized'] do
          lambda do
            FbGraph::User.new('me').family
          end.should raise_exception(FbGraph::Unauthorized)
        end
      end
    end

    context 'when access_token is given' do
      it 'should return family members as FbGraph::User' do
        mock_graph :get, 'me/family', 'users/family/me_public', :access_token => 'access_token' do
          users = FbGraph::User.new('me', :access_token => 'access_token').family
          users.first.should == FbGraph::User.new(
            '720112389',
            :access_token => 'access_token',
            :name => 'TD Lee',
            :relationship => 'brother'
          )
          users.each do |user|
            user.should be_instance_of(FbGraph::User)
          end
        end
      end
    end
  end
end