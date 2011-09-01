require 'spec_helper'

describe FbGraph::AdAccount, '.new' do
  it 'should setup all supported attributes' do
    attributes = {
      :id => 'act_12345566',
      :account_id => 12345566,
      :name => 'Test Ad Account',
      :account_status => 1,
      :daily_spend_limit => 20000,
      :currency => "USD",
      :timezone_id => 1,
      :timezone_name => "America/Los_Angeles"
    }
    ad_account = FbGraph::AdAccount.new(attributes.delete(:id), attributes)
    ad_account.identifier.should == "act_12345566"
    ad_account.account_id.should == 12345566
    ad_account.name.should == "Test Ad Account"
    ad_account.account_status.should == 1
    ad_account.daily_spend_limit.should == 20000
    ad_account.currency.should == "USD"
    ad_account.timezone_id.should == 1
    ad_account.timezone_name.should == "America/Los_Angeles"
  end
end


describe FbGraph::AdAccount, '.fetch' do
  it 'should get the ad account' do
    mock_graph :get, 'act_12345566', 'ad_accounts/test_ad_account', :access_token => 'access_token' do
      ad_account = FbGraph::AdAccount.fetch('act_12345566', :access_token => 'access_token')

      ad_account.identifier.should == "act_12345566"
      ad_account.account_id.should == 12345566
      ad_account.name.should == "Test Ad Account"
      ad_account.account_status.should == 1
      ad_account.daily_spend_limit.should == 20000
      ad_account.currency.should == "USD"
      ad_account.timezone_id.should == 1
      ad_account.timezone_name.should == "America/Los_Angeles"
    end
  end
end
