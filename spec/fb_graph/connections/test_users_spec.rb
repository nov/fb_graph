require 'spec_helper'

describe FbGraph::Connections::TestUsers, '#test_users' do
  before do
    @app = FbGraph::Application.new('client_id', :secret => 'secret')
    fake_json(:get, 'client_id/accounts/test-users?access_token=access_token', 'applications/test_users/private')
  end

  context 'when access_token is not given' do
    it 'should get access_token first' do
      lambda do
        @app.test_users
      end.should request_to('oauth/access_token', :post)
    end
  end

  context 'when access_token is given' do
    it 'should return test_users as FbGraph::TestUser' do
      @app.access_token = 'access_token'
      test_users = @app.test_users
      test_users.each do |test_user|
        test_user.should be_instance_of(FbGraph::TestUser)
      end
    end
  end
end

describe FbGraph::Connections::TestUsers, '#test_user!' do
  before do
    @app = FbGraph::Application.new('client_id', :secret => 'secret')
    fake_json(:post, 'client_id/accounts/test-users', 'applications/test_users/created')
  end

  context 'when access_token is not given' do
    it 'should get access_token first' do
      lambda do
        @app.test_user!
      end.should request_to('oauth/access_token', :post)
    end
  end

  context 'when access_token is given' do
    it 'should return a FbGraph::TestUser' do
      @app.access_token = 'access_token'
      test_user = @app.test_user!
      test_user.should be_instance_of FbGraph::TestUser
    end
  end
end