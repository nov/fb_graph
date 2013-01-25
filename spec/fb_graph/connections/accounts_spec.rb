require 'spec_helper'

describe FbGraph::Connections::Accounts do
  describe '#accounts' do
    context 'when included by FbGraph::User' do
      context 'when no access_token given' do
        it 'should raise FbGraph::Unauthorized' do
          mock_graph :get, 'matake/accounts', 'users/accounts/matake_public', :status => [401, 'Unauthorized'] do
            lambda do
              FbGraph::User.new('matake').accounts
            end.should raise_exception(FbGraph::Unauthorized)
          end
        end
      end

      context 'when access_token is given' do
        it 'should return accounts as FbGraph::Page or FbGraph::Application' do
          mock_graph :get, 'matake/accounts', 'users/accounts/matake_private', :access_token => 'access_token' do
            accounts = FbGraph::User.new('matake', :access_token => 'access_token').accounts
            accounts.class.should == FbGraph::Connection
            accounts.first.should == FbGraph::Page.new(
              '140478125968442',
              :access_token => 'access_token',
              :name => 'OAuth.jp',
              :category => 'Community organization',
              :perms => [
                "ADMINISTER",
                "EDIT_PROFILE",
                "CREATE_CONTENT",
                "MODERATE_CONTENT",
                "CREATE_ADS",
                "BASIC_ADMIN"
              ]
            )
            accounts.last.should == FbGraph::Application.new(
              '159306934123399',
              :access_token => 'access_token',
              :name => 'Rack::OAuth2 Sample'
            )
            accounts[0, 9].each do |account|
              account.should be_instance_of(FbGraph::Page)
            end
            accounts[9, 4].each do |account|
              account.should be_instance_of(FbGraph::Application)
            end
          end
        end

        context 'when manage_pages permission given' do
          it 'should has special access_token behalf of the page' do
            mock_graph :get, 'matake/accounts', 'users/accounts/matake_private_with_manage_pages_permission', :access_token => 'access_token_for_user' do
              accounts = FbGraph::User.new('matake', :access_token => 'access_token_for_user').accounts
              accounts.first.should == FbGraph::Page.new(
                '140478125968442',
                :access_token => 'access_token_for_oauth_jp',
                :name => 'OAuth.jp',
                :category => 'Technology'
              )
            end
          end
        end
      end
    end

    context 'when included by FbGraph::Application' do
      it 'should return an array of TestUser' do
        mock_graph :get, 'app/accounts', 'applications/accounts/private', :access_token => 'access_token_for_app' do
          accounts = FbGraph::Application.new('app', :access_token => 'access_token_for_app').accounts
          accounts.first.should == FbGraph::TestUser.new(
            '100002527044219',
            :access_token => '117950878254050|2.AQA7fQ_BuZqxAiHc.3600.1308646800.0-100002527044219|T1wRNmvnx5j5nw-2x00gZgdBjbo',
            :login_url => 'https://www.facebook.com/platform/test_account_login.php?user_id=100002527044219&n=SOlkQGg6Icr5BeI'
          )
        end
      end
    end
  end
end
