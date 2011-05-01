require 'spec_helper'

describe FbGraph::Connections::Permissions, '#permissions' do
  let :permissions do
    mock_graph :get, 'me/permissions', 'users/permissions/me_private', :params => {
      :access_token => 'access_token'
    } do
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
end
