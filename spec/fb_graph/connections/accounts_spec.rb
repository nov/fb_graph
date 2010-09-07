require File.join(File.dirname(__FILE__), '../../spec_helper')

context 'when included by FbGraph::User' do
  describe FbGraph::Connections::Accounts, '#accounts' do
    before(:all) do
      fake_json(:get, 'matake/accounts', 'users/accounts/matake_public')
      fake_json(:get, 'matake/accounts?access_token=access_token', 'users/accounts/matake_private')
      fake_json(:get, 'matake/accounts?access_token=access_token_with_manage_pages_permission', 'users/accounts/matake_private_with_manage_pages_permission')
    end

    context 'when no access_token given' do
      it 'should raise FbGraph::Unauthorized' do
        lambda do
          FbGraph::User.new('matake').accounts
        end.should raise_exception(FbGraph::Unauthorized)
      end
    end

    context 'when access_token is given' do
      it 'should return accounts as FbGraph::Page' do
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

      context 'when manage_pages permission given' do
        it 'should has special access_token behalf of the page' do
          accounts = FbGraph::User.new('matake', :access_token => 'access_token_with_manage_pages_permission').accounts
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
