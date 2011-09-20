require 'spec_helper'

describe FbGraph::AdUser do
  subject { ad_user }
  let(:ad_user) { FbGraph::AdUser.new(attributes[:uid], attributes) }
  let(:role) { FbGraph::AdUser::ROLES[:admin] }
  let :attributes do
    {
      :uid => '123456',
      :permissions => [1,3,4,7],
      :role => role
    }
  end

  it 'should setup all supported attributes' do
    ad_user.identifier.should == "123456"
    ad_user.permissions.should == [1,3,4,7]
    ad_user.role.should == 1001
  end

  describe 'roles' do
    context 'when admin user' do
      let(:role) { FbGraph::AdUser::ROLES[:admin] }
      its(:admin_access?) { should == true }
      its(:general_access?) { should == false }
      its(:reports_only_access?) { should == false }
    end

    context 'when general user' do
      let(:role) { FbGraph::AdUser::ROLES[:general] }
      its(:admin_access?) { should == false }
      its(:general_access?) { should == true }
      its(:reports_only_access?) { should == false }
    end

    context 'when general user' do
      let(:role) { FbGraph::AdUser::ROLES[:reports_only] }
      its(:admin_access?) { should == false }
      its(:general_access?) { should == false }
      its(:reports_only_access?) { should == true }
    end
  end

  describe ".fetch" do
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
end
