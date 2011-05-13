require 'spec_helper'

describe FbGraph::Connections::Accounts, '#accounts' do
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
      it 'should return accounts as FbGraph::Page' do
        mock_graph :get, 'matake/accounts', 'users/accounts/matake_private', :access_token => 'access_token' do
          accounts = FbGraph::User.new('matake', :access_token => 'access_token').accounts
          accounts.class.should == FbGraph::Connection
          accounts.first.should == FbGraph::Page.new(
            '140478125968442',
            :access_token => 'access_token',
            :name => 'OAuth.jp',
            :category => 'Technology'
          )
          accounts.each do |account|
            account.should be_instance_of(FbGraph::Page)
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
end
