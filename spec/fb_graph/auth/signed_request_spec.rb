require 'spec_helper'

describe FbGraph::Auth::SignedRequest, '.parse' do
  before do
    @client = Rack::OAuth2::Client.new(:identifier => 'client_id', :secret => 'client_secret')
    @signed_request = "LqsgnfcsRdfjOgyW6ZuSLpGBVsxUBegEqai4EcrWS0A=.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImV4cGlyZXMiOjAsImlzc3VlZF9hdCI6MTI5ODc4MzczOSwib2F1dGhfdG9rZW4iOiIxMzQxNDU2NDMyOTQzMjJ8MmI4YTZmOTc1NTJjNmRjZWQyMDU4MTBiLTU3OTYxMjI3NnxGS1o0akdKZ0JwN2k3bFlrOVhhUk1QZ3lhNnMiLCJ1c2VyIjp7ImNvdW50cnkiOiJqcCIsImxvY2FsZSI6ImVuX1VTIiwiYWdlIjp7Im1pbiI6MjF9fSwidXNlcl9pZCI6IjU3OTYxMjI3NiJ9"
  end

  it 'should verify signature and return data' do
    data = FbGraph::Auth::SignedRequest.verify(@client, @signed_request)
    data[:expires].should          == 0
    data[:algorithm].should        == 'HMAC-SHA256'
    data[:user_id].should          == '579612276'
    data[:oauth_token].should      == '134145643294322|2b8a6f97552c6dced205810b-579612276|FKZ4jGJgBp7i7lYk9XaRMPgya6s'
    data[:issued_at].should        == 1298783739
    data[:user][:country].should   == 'jp'
    data[:user][:locale].should    == 'en_US'
    data[:user][:age][:min].should == 21
  end
end


