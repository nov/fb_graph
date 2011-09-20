require 'spec_helper'

describe FbGraph::AdUser, '.new' do
  it 'should setup all supported attributes' do
    attributes = {
      :id => '123456',
      :permissions => [1,3,4,7],
      :role => 1001
    }
    ad_user = FbGraph::AdUser.new(attributes.delete(:id), attributes)
    ad_user.identifier.should == "123456"
    ad_user.permissions.should == [1,3,4,7]
    ad_user.role.should == 1001
  end
end

describe FbGraph::AdUser, ".fetch" do
  let(:ad_user) do
    FbGraph::AdUser.new(
      "579612276",
      :permissions => [1,3,4,7],
      :role => 1001
    )
  end

  it "should fetch the regular User and add the AdUser attributes" do
    mock_graph :get, '579612276', 'users/me_private', :access_token => 'access_token' do
      fetched_user = ad_user.fetch(:access_token => 'access_token')

      fetched_user.identifier.should == "579612276"
      fetched_user.first_name = "Nov"
      fetched_user.last_name = "Matake"
      fetched_user.permissions.should == [1,3,4,7]
      fetched_user.role.should == 1001
    end
  end
end
