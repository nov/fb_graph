require 'spec_helper'

describe FbGraph::AdUser do
  subject { ad_user }
  let(:ad_user) { FbGraph::AdUser.new(attributes[:uid], attributes) }
  let(:role) { FbGraph::AdUser::ROLES[:admin] }
  let(:permissions) { [1,3,4,7] }
  let :attributes do
    {
      :uid => '123456',
      :permissions => permissions,
      :role => role
    }
  end

  it 'should setup all supported attributes' do
    ad_user.identifier.should == "123456"
    ad_user.permissions.should == permissions
    ad_user.role.should == role
  end

  describe 'role' do
    FbGraph::AdUser::ROLES.keys.each do |role|
      context "when #{role} role given" do
        let(:role) { FbGraph::AdUser::ROLES[role] }
        its(:"#{role}_access?") { should be_true }
        (FbGraph::AdUser::ROLES.keys - [role]).each do |no_access|
          its(:"#{no_access}_access?") { should be_false }
        end
      end
    end
  end

  describe 'permissions' do
    FbGraph::AdUser::PERMISSIONS.keys.each do |permission|
      context "when #{permission} permission given" do
        let(:permissions) { [FbGraph::AdUser::PERMISSIONS[permission]] }
        its(:"#{permission}_access?") { should be_true }
        (FbGraph::AdUser::PERMISSIONS.keys - [permission]).each do |no_access|
          its(:"#{no_access}_access?") { should be_false }
        end
      end
    end
  end

  describe ".fetch" do
    let(:ad_user) do
      FbGraph::AdUser.new(
        "579612276",
        :permissions => permissions,
        :role => role
      )
    end

    it "should fetch the regular User and add the AdUser attributes" do
      mock_graph :get, '579612276', 'users/me_private', :access_token => 'access_token' do
        fetched_user = ad_user.fetch(:access_token => 'access_token')

        fetched_user.identifier.should == "579612276"
        fetched_user.first_name = "Nov"
        fetched_user.last_name = "Matake"
        fetched_user.permissions.should == permissions
        fetched_user.role.should == role
      end
    end
  end
end
