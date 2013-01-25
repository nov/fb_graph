require 'spec_helper'

describe FbGraph::Connections::AdAccounts, '#ad_accounts' do
  context 'when included by FbGraph::User' do
    context 'when access_token is given' do
      it 'should return ad_accounts as FbGraph::AdAccount' do
        mock_graph :get, 'me/adaccounts', 'users/ad_accounts/me_ad_accounts', :access_token => 'access_token' do
          ad_accounts = FbGraph::User.me('access_token').ad_accounts
          ad_accounts.size.should == 2
          ad_accounts.each { |ad_account| ad_account.should be_instance_of(FbGraph::AdAccount) }
          ad_accounts.first.should == FbGraph::AdAccount.new(
            "act_108370185937777",
            :account_id => 108370185937777,
            :name => "",
            :account_status => 1,
            :currency => "USD",
            :timezone_id => 1,
            :timezone_name => "America/Los_Angeles",
            :daily_spend_limit => 5000,
            :users => [{"uid" => 10000294098888, :permissions => [1,2,3,4,5,7], :role => 1001}],
            :capabilities => [],
            :access_token => 'access_token'
          )
        end
      end
    end
  end
end
