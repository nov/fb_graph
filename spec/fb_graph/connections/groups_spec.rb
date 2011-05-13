require 'spec_helper'

describe FbGraph::Connections::Groups, '#groups' do
  context 'when included by FbGraph::User' do
    context 'when no access_token given' do
      it 'should raise FbGraph::Unauthorized' do
        mock_graph :get, 'matake/groups', 'users/groups/matake_public', :status => [401, 'Unauthorized'] do
          lambda do
            FbGraph::User.new('matake').groups
          end.should raise_exception(FbGraph::Unauthorized)
        end
      end
    end

    context 'when access_token is given' do
      it 'should return groups as FbGraph::Group' do
        mock_graph :get, 'matake/groups', 'users/groups/matake_private', :access_token => 'access_token' do
          groups = FbGraph::User.new('matake', :access_token => 'access_token').groups
          groups.first.should == FbGraph::Group.new(
            '115286585902',
            :access_token => 'access_token',
            :name => 'iPhone 3G S'
          )
          groups.each do |group|
            group.should be_instance_of(FbGraph::Group)
          end
        end
      end
    end
  end
end