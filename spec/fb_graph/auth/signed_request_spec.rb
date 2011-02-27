require File.join(File.dirname(__FILE__), '../../spec_helper')

describe FbGraph::Auth::SignedRequest, '.parse' do
  before do
    @client = OAuth2::Client.new('client_id', 'client_secret')
    @signed_request = "LqsgnfcsRdfjOgyW6ZuSLpGBVsxUBegEqai4EcrWS0A=.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImV4cGlyZXMiOjAsImlzc3VlZF9hdCI6MTI5ODc4MzczOSwib2F1dGhfdG9rZW4iOiIxMzQxNDU2NDMyOTQzMjJ8MmI4YTZmOTc1NTJjNmRjZWQyMDU4MTBiLTU3OTYxMjI3NnxGS1o0akdKZ0JwN2k3bFlrOVhhUk1QZ3lhNnMiLCJ1c2VyIjp7ImNvdW50cnkiOiJqcCIsImxvY2FsZSI6ImVuX1VTIiwiYWdlIjp7Im1pbiI6MjF9fSwidXNlcl9pZCI6IjU3OTYxMjI3NiJ9"
  end

  it 'should verify signature and return data' do
    data = FbGraph::Auth::SignedRequest.verify(@client, @cookie)
    p data
  end
end


