require 'spec_helper'

describe FbGraph::Auth do
  let :optional_attributes do
    {}
  end
  let(:auth) { FbGraph::Auth.new('client_id', 'client_secret', optional_attributes) }
  subject { auth }

  its(:client) { should be_a(Rack::OAuth2::Client) }
  describe 'client' do
    subject { auth.client }
    let :optional_attributes do
      {:redirect_uri => 'https://client.example.com/callback'}
    end
    its(:identifier) { should == 'client_id' }
    its(:secret) { should == 'client_secret' }
    its(:redirect_uri) { should == 'https://client.example.com/callback' }
  end

  context 'when invalid cookie given' do
    let :optional_attributes do
      {:cookie => 'invalid'}
    end
    it 'should raise FbGraph::VerificationFailed' do
      expect { auth }.to raise_exception(FbGraph::Auth::VerificationFailed)
    end
  end

  context 'when invalid cookie given' do
    let :optional_attributes do
      {:signed_request => 'invalid'}
    end

    it 'should raise FbGraph::VerificationFailed' do
      expect { auth }.to raise_exception(FbGraph::Auth::VerificationFailed)
    end
  end

  describe '#authorized?' do
    context 'when access_token is given' do
      before do
        auth.access_token = 'access_token'
      end
      its(:authorized?) { should be_true }
    end

    context 'otherwise' do
      its(:authorized?) { should be_false }
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

  describe '#from_cookie' do
    let :cookie do
      {
        'fbsr_client_id' => "9heZHFs6tDH/Nif4CqmBaMQ8nKEOc5g2WgVJa10LF00.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImNvZGUiOiI4ZDYwZDY4NDA4MmQ1NjczMjY3MWUxNzAuMS01Nzk2MTIyNzZ8N2pkVlp6MlNLNUY2b0gtQ21FQWtZZVpuVjEwIiwiaXNzdWVkX2F0IjoxMzEyOTUzOTcxLCJ1c2VyX2lkIjo1Nzk2MTIyNzZ9"
      }
    end

    it 'should exchange code with access token' do
      expect { auth.from_cookie(cookie) }.to request_to '/oauth/access_token', :post
    end

    it 'should setup user and access_token' do
      mock_graph :post, '/oauth/access_token', 'token_response' do
        auth.access_token.should be_nil
        auth.user.should be_nil
        auth.from_cookie(cookie)
        auth.access_token.should be_a Rack::OAuth2::AccessToken::Legacy
        auth.access_token.access_token.should      == 'token'
        auth.user.should be_a FbGraph::User
        auth.user.identifier.should                == 579612276
        auth.user.access_token.access_token.should == 'token'
        auth.data.should == {
          "algorithm" => "HMAC-SHA256",
          "code" => "8d60d684082d56732671e170.1-579612276|7jdVZz2SK5F6oH-CmEAkYeZnV10",
          "issued_at" => 1312953971,
          "user_id" => 579612276
        }
      end
    end

    context 'when invalid cookie given' do
      it 'should raise FbGraph::VerificationFailed' do
        lambda do
          auth.from_cookie('invalid')
        end.should raise_exception(FbGraph::Auth::VerificationFailed)
      end
    end

    context 'when Rack::OAuth2::Client::Error occurred' do
      context 'when BadRequest' do
        it 'should raise FbGraph::BadRequest' do
          mock_graph :post, 'oauth/access_token', 'blank', :status => [400, 'BadRequest'] do
            lambda do
              auth.from_cookie(cookie)
            end.should raise_exception FbGraph::BadRequest
          end
        end
      end

      context 'when Unauthorized' do
        it 'should raise FbGraph::Unauthorized' do
          mock_graph :post, 'oauth/access_token', 'blank', :status => [401, 'Unauthorized'] do
            lambda do
              auth.from_cookie(cookie)
            end.should raise_exception FbGraph::Unauthorized
          end
        end
      end

      context 'otherwise' do
        it 'should raise FbGraph::Exception' do
          mock_graph :post, 'oauth/access_token', 'blank', :status => [403, 'Forbidden'] do
            lambda do
              auth.from_cookie(cookie)
            end.should raise_exception FbGraph::Exception
          end
        end
      end
    end
  end

  describe '#from_signed_request' do
    let :signed_request do
      "LqsgnfcsRdfjOgyW6ZuSLpGBVsxUBegEqai4EcrWS0A=.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImV4cGlyZXMiOjAsImlzc3VlZF9hdCI6MTI5ODc4MzczOSwib2F1dGhfdG9rZW4iOiIxMzQxNDU2NDMyOTQzMjJ8MmI4YTZmOTc1NTJjNmRjZWQyMDU4MTBiLTU3OTYxMjI3NnxGS1o0akdKZ0JwN2k3bFlrOVhhUk1QZ3lhNnMiLCJ1c2VyIjp7ImNvdW50cnkiOiJqcCIsImxvY2FsZSI6ImVuX1VTIiwiYWdlIjp7Im1pbiI6MjF9fSwidXNlcl9pZCI6IjU3OTYxMjI3NiJ9"
    end

    it 'should setup user and access_token' do
      auth.access_token.should be_nil
      auth.user.should be_nil
      auth.from_signed_request(signed_request)
      auth.access_token.should be_a Rack::OAuth2::AccessToken::Legacy
      auth.access_token.access_token.should      == '134145643294322|2b8a6f97552c6dced205810b-579612276|FKZ4jGJgBp7i7lYk9XaRMPgya6s'
      auth.user.should be_a FbGraph::User
      auth.user.identifier.should                == '579612276'
      auth.user.access_token.access_token.should == '134145643294322|2b8a6f97552c6dced205810b-579612276|FKZ4jGJgBp7i7lYk9XaRMPgya6s'
      auth.data.should include(
        "expires"=>0,
        "algorithm"=>"HMAC-SHA256",
        "issued_at"=>1298783739
      )
      auth.data['user'].should include(
        "country"=>"jp",
        "locale"=>"en_US",
        "age"=>{"min"=>21}
      )
    end

    context 'when expires included' do
      let :signed_request do
        "bzMUNepndPnmce-QdJqvkigxr_6iEzOf-ZNl-ZitvpA.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImV4cGlyZXMiOjEzMjA2NjAwMDAsImlzc3VlZF9hdCI6MTI5ODc4MzczOSwib2F1dGhfdG9rZW4iOiIxMzQxNDU2NDMyOTQzMjJ8MmI4YTZmOTc1NTJjNmRjZWQyMDU4MTBiLTU3OTYxMjI3NnxGS1o0akdKZ0JwN2k3bFlrOVhhUk1QZ3lhNnMiLCJ1c2VyIjp7ImNvdW50cnkiOiJqcCIsImxvY2FsZSI6ImVuX1VTIiwiYWdlIjp7Im1pbiI6MjF9fSwidXNlcl9pZCI6IjU3OTYxMjI3NiJ9"
      end

      it 'should have expires_in' do
        auth.from_signed_request(signed_request)
        auth.access_token.expires_in.should be_a Integer
      end
    end

    context 'when invalid signed_request given' do
      it 'should raise FbGraph::VerificationFailed' do
        lambda do
          auth.from_signed_request('invalid.signed_request')
        end.should raise_exception(FbGraph::Auth::VerificationFailed)
      end
    end
  end

  describe "#exchange_token!" do
    it 'should get new token' do
      mock_graph :post, '/oauth/access_token', 'token_with_expiry' do
        auth.exchange_token! 'old_token'
        auth.access_token.access_token.should == 'new_token'
        auth.access_token.expires_in.should == 3600
      end
    end

    context 'when Rack::OAuth2::Client::Error occurred' do
      context 'when BadRequest' do
        it 'should raise FbGraph::BadRequest' do
          mock_graph :post, 'oauth/access_token', 'blank', :status => [400, 'BadRequest'] do
            lambda do
              auth.exchange_token! 'old_token'
            end.should raise_exception FbGraph::BadRequest
          end
        end
      end

      context 'when Unauthorized' do
        it 'should raise FbGraph::Unauthorized' do
          mock_graph :post, 'oauth/access_token', 'blank', :status => [401, 'Unauthorized'] do
            lambda do
              auth.exchange_token! 'old_token'
            end.should raise_exception FbGraph::Unauthorized
          end
        end
      end

      context 'otherwise' do
        it 'should raise FbGraph::Exception' do
          mock_graph :post, 'oauth/access_token', 'blank', :status => [403, 'Forbidden'] do
            lambda do
              auth.exchange_token! 'old_token'
            end.should raise_exception FbGraph::Exception
          end
        end
      end
    end
  end
end

