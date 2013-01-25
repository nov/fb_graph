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
      :timezone_name => "America/Los_Angeles",
      :capabilities => [1,2,3],
      :account_groups =>[{"account_group_id"=>12344321, "name"=>"Account Group", "status"=>1}],
      :is_personal => 1,
      :business_name => "Business Inc.",
      :business_street => "123 Fake St.",
      :business_street2 => "Apt. 2B",
      :business_city => "New York",
      :business_state => "Alabama",
      :business_zip => "33333",
      :business_country_code => "US",
      :vat_status => 1,
      :agency_client_declaration => {
        "agency_representing_client"=>1,
        "client_based_in_france"=>0,
        "has_written_mandate_from_advertiser"=>1,
        "is_client_paying_invoices"=>1,
        "client_name"=>"Client Smith",
        "client_email_address"=>"fake@example.com",
        "client_street" => "321 Real St.",
        "client_street2" => "Suite 123",
        "client_city" => "Los Angeles",
        "client_province" => "AB",
        "client_postal_code" => "33433",
        "client_country_code" => "CA"
      },
      :spend_cap => 1500,
      :amount_spent => 1499
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
    ad_account.capabilities.should == [1,2,3]
    ad_account.account_groups.should == [{"account_group_id"=>12344321, "name"=>"Account Group", "status"=>1}]
    ad_account.is_personal.should == 1
    ad_account.business_name.should == "Business Inc."
    ad_account.business_street.should == "123 Fake St."
    ad_account.business_street2.should == "Apt. 2B"
    ad_account.business_city.should == "New York"
    ad_account.business_state.should == "Alabama"
    ad_account.business_zip.should == "33333"
    ad_account.business_country_code.should == "US"
    ad_account.vat_status.should == 1
    ad_account.agency_client_declaration.should == {
        "agency_representing_client"=>1,
        "client_based_in_france"=>0,
        "has_written_mandate_from_advertiser"=>1,
        "is_client_paying_invoices"=>1,
        "client_name"=>"Client Smith",
        "client_email_address"=>"fake@example.com",
        "client_street" => "321 Real St.",
        "client_street2" => "Suite 123",
        "client_city" => "Los Angeles",
        "client_province" => "AB",
        "client_postal_code" => "33433",
        "client_country_code" => "CA"
      }
    ad_account.spend_cap.should == 1500
    ad_account.amount_spent.should == 1499
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
      ad_account.capabilities.should == [1,2,3]
      ad_account.account_groups.should == [{"account_group_id"=>12344321, "name"=>"Account Group", "status"=>1}]
      ad_account.is_personal.should == 1
      ad_account.business_name.should == "Business Inc."
      ad_account.business_street.should == "123 Fake St."
      ad_account.business_street2.should == "Apt. 2B"
      ad_account.business_city.should == "New York"
      ad_account.business_state.should == "Alabama"
      ad_account.business_zip.should == "33333"
      ad_account.business_country_code.should == "US"
      ad_account.vat_status.should == 1
      ad_account.agency_client_declaration.should == {
        "agency_representing_client"=>1,
        "client_based_in_france"=>0,
        "has_written_mandate_from_advertiser"=>1,
        "is_client_paying_invoices"=>1,
        "client_name"=>"Client Smith",
        "client_email_address"=>"fake@example.com",
        "client_street" => "321 Real St.",
        "client_street2" => "Suite 123",
        "client_city" => "Los Angeles",
        "client_province" => "AB",
        "client_postal_code" => "33433",
        "client_country_code" => "CA"
      }
      ad_account.spend_cap.should == 1500
      ad_account.amount_spent.should == 1499
    end
  end
end
