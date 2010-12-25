require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::TestUser, '.new' do

  it 'should setup all supported attributes' do
    attributes = {
      :id => 12345,
      :access_token => 'access_token',
      :login_url => 'https://www.facebook.com/login/test-user/12345'
    }
    test_user = FbGraph::TestUser.new(attributes.delete(:id), attributes)
    test_user.login_url.should == 'https://www.facebook.com/login/test-user/12345'
  end

end

describe FbGraph::TestUser, '.friend!' do

  before do
    @u1 = FbGraph::TestUser.new(111, :access_token => 'token1')
    @u2 = FbGraph::TestUser.new(222, :access_token => 'token2')
  end

  it 'should POST twice' do
    lambda do
      @u1.friend! @u2
    end.should raise_error(
      FakeWeb::NetConnectNotAllowedError,
      "Real HTTP connections are disabled. Unregistered request: POST https://graph.facebook.com/111/friends/222"
    )
    fake_json(:post, '111/friends/222', 'true')
    lambda do
      @u1.friend! @u2
    end.should raise_error(
      FakeWeb::NetConnectNotAllowedError,
      "Real HTTP connections are disabled. Unregistered request: POST https://graph.facebook.com/222/friends/111"
    )
    fake_json(:post, '222/friends/111', 'true')
    lambda do
      @u1.friend! @u2
    end.should_not raise_error(FakeWeb::NetConnectNotAllowedError)
  end

end