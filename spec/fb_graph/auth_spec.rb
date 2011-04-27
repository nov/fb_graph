require 'spec_helper'

describe FbGraph::Auth, '.new' do
  it 'should setup Rack::OAuth2::Client' do
    auth = FbGraph::Auth.new('client_id', 'client_secret')
    auth.client.should be_a(Rack::OAuth2::Client)
    auth.client.identifier.should     == 'client_id'
    auth.client.secret.should == 'client_secret'
  end

  context 'when invalid cookie given' do
    it 'should raise FbGraph::VerificationFailed' do
      lambda do
        FbGraph::Auth.new('client_id', 'client_secret', :cookie => 'invalid')
      end.should raise_exception(FbGraph::Auth::VerificationFailed)
    end
  end

  context 'when invalid cookie given' do
    it 'should raise FbGraph::VerificationFailed' do
      lambda do
        FbGraph::Auth.new('client_id', 'client_secret', :signed_request => 'invalid')
      end.should raise_exception(FbGraph::Auth::VerificationFailed)
    end
  end
end

describe FbGraph::Auth, '#from_cookie' do
  before do
    @auth = FbGraph::Auth.new('client_id', 'client_secret')
    @expires_at = Time.parse('2020-12-31 12:00:00')
    @cookie = {
      'fbs_client_id' => "access_token=t&expires=#{@expires_at.to_i}&secret=s&session_key=k&sig=b06a0540959470e731cc3bc2ef31a007&uid=12345"
    }
  end

  it 'should fetch user and access_token from fbs_APP_ID cookie' do
    @auth.access_token.should be_nil
    @auth.user.should be_nil
    @auth.from_cookie(@cookie)
    @auth.access_token.access_token.should      == 't'
    @auth.access_token.expires_in.should        be_within(1).of(@expires_at - Time.now)
    @auth.user.identifier.should                == '12345'
    @auth.user.access_token.access_token.should == 't'
  end

  context 'when invalid cookie given' do
    it 'should raise FbGraph::VerificationFailed' do
      lambda do
        @auth.from_cookie('invalid')
      end.should raise_exception(FbGraph::Auth::VerificationFailed)
    end
  end
end

describe FbGraph::Auth, '#from_signed_request' do
  before do
    @signed_request = "LqsgnfcsRdfjOgyW6ZuSLpGBVsxUBegEqai4EcrWS0A=.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImV4cGlyZXMiOjAsImlzc3VlZF9hdCI6MTI5ODc4MzczOSwib2F1dGhfdG9rZW4iOiIxMzQxNDU2NDMyOTQzMjJ8MmI4YTZmOTc1NTJjNmRjZWQyMDU4MTBiLTU3OTYxMjI3NnxGS1o0akdKZ0JwN2k3bFlrOVhhUk1QZ3lhNnMiLCJ1c2VyIjp7ImNvdW50cnkiOiJqcCIsImxvY2FsZSI6ImVuX1VTIiwiYWdlIjp7Im1pbiI6MjF9fSwidXNlcl9pZCI6IjU3OTYxMjI3NiJ9"
    @auth = FbGraph::Auth.new('client_id', 'client_secret')
  end

  it 'should fetch user and access_token from signed_request' do
    @auth.access_token.should be_nil
    @auth.user.should be_nil
    @auth.from_signed_request(@signed_request)
    @auth.access_token.access_token.should      == '134145643294322|2b8a6f97552c6dced205810b-579612276|FKZ4jGJgBp7i7lYk9XaRMPgya6s'
    @auth.user.identifier.should                == '579612276'
    @auth.user.access_token.access_token.should == '134145643294322|2b8a6f97552c6dced205810b-579612276|FKZ4jGJgBp7i7lYk9XaRMPgya6s'
    @auth.data.should include(
      "expires"=>0,
      "algorithm"=>"HMAC-SHA256",
      "issued_at"=>1298783739
    )
    @auth.data['user'].should include(
      "country"=>"jp",
      "locale"=>"en_US",
      "age"=>{"min"=>21}
    )
  end

  context 'when invalid signed_request given' do
    it 'should raise FbGraph::VerificationFailed' do
      lambda do
        @auth.from_signed_request('invalid.signed_request')
      end.should raise_exception(FbGraph::Auth::VerificationFailed)
    end
  end
end

describe FbGraph::Auth do
  let(:auth) { FbGraph::Auth.new('client_id', 'client_secret') }

  describe '#authorized?' do
    subject { auth.authorized? }

    context 'when access_token is given' do
      before do
        auth.access_token = 'access_token'
      end
      it { should be_true }
    end

    context 'otherwise' do
      it { should be_false }
    end
  end

  describe '#authorize_uri' do
    let(:canvas_uri) { 'http://client.example.com/canvas' }
    subject { auth.authorize_uri(canvas_uri) }
    it { should == "https://www.facebook.com/dialog/oauth?client_id=client_id&redirect_uri=#{CGI.escape canvas_uri}" }

    context 'when params are given' do
      subject { auth.authorize_uri(canvas_uri, :scope => [:scope1, :scope2], :state => 'state1') }
      it { should == "https://www.facebook.com/dialog/oauth?client_id=client_id&redirect_uri=#{CGI.escape canvas_uri}&scope=#{CGI.escape "scope1,scope2"}&state=state1" }
    end
  end
end

