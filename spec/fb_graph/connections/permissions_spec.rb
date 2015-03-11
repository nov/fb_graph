require 'spec_helper'

describe FbGraph::Connections::Permissions do
  describe '#permissions' do

    context 'v1 API' do
      let :permissions do
        mock_graph :get, 'me/permissions', 'users/permissions/me_private', :access_token => 'access_token' do
          FbGraph::User.me('access_token').permissions
        end
      end

      it 'should be an Array of Symbol' do
        permissions.should be_instance_of Array
        permissions.should_not be_blank
        permissions.each do |permission|
          permission.should be_instance_of Symbol
        end
      end

      context 'when blank' do
        it 'should return blank array' do
          mock_graph :get, 'me/permissions', 'users/permissions/blank', :access_token => 'access_token' do
            permissions = FbGraph::User.me('access_token').permissions
            permissions.should == []
          end
        end
      end
    end

    context 'v2 API' do
      context 'using global config' do
        before(:each) do
          FbGraph.v2!
        end

        after(:each) do
          FbGraph.v1!
        end

        it 'should be an Array of Hash' do
          mock_graph :get, 'v2.2/me/permissions', 'users/permissions/v2', :access_token => 'access_token' do
            permissions = FbGraph::User.me('access_token').permissions
            permissions.should be_instance_of Array
            permissions.should_not be_blank
            permissions.each do |permission|
              permission.should be_instance_of Symbol
            end
          end
        end

        context 'when blank' do
          it 'should return blank array' do
            mock_graph :get, 'v2.2/me/permissions', 'users/permissions/blank', :access_token => 'access_token' do
              permissions = FbGraph::User.me('access_token').permissions
              permissions.should == []
            end
          end
        end
      end

      context 'using local config' do
        it 'should be an Array of Hash' do
          mock_graph :get, 'v2.2/me/permissions', 'users/permissions/v2', :access_token => 'access_token' do
            permissions = FbGraph::User.me('access_token').permissions(:api_version => 'v2.2')
            permissions.should be_instance_of Array
            permissions.should_not be_blank
            permissions.each do |permission|
              permission.should be_instance_of Symbol
            end
          end
        end
      end
    end
  end

  describe '#revoke!' do
    it 'should DELETE /:user_id/permissions' do
      mock_graph :delete, 'me/permissions', 'true', :access_token => 'access_token' do
        FbGraph::User.me('access_token').revoke!
      end
    end

    it 'should support revoking specific permission' do
      mock_graph :delete, 'me/permissions', 'true', :access_token => 'access_token', :params => {
        :permission => :email
      } do
        FbGraph::User.me('access_token').revoke! :email
      end
    end
  end
end
