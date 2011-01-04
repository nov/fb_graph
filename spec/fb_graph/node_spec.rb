require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Node, '.new' do

  it 'should setup endpoint' do
    FbGraph::Node.new('matake').endpoint.should == File.join(FbGraph::ROOT_URL, 'matake')
  end

  it 'should support access_token option' do
    FbGraph::Node.new('matake', :access_token => 'access_token').access_token.should == 'access_token'
  end

end

describe FbGraph::Node, '#stringfy_access_token' do
  it 'should support OAuth2::AccessToken' do
    client = OAuth2::Client.new('client_id', 'client_secret')
    node = FbGraph::Node.new('identifier', :access_token => OAuth2::AccessToken.new(client, 'token', 'secret'))
    params = node.send :stringfy_access_token, {}
    params[:access_token].should == 'token'
  end
end

describe FbGraph::Node, '#handle_response' do
  it 'should handle null/false response' do
    node = FbGraph::Node.new('identifier')
    null_response = node.send :handle_response do
      RestClient::Response.create 'null', nil, nil
    end
    null_response.should be_nil
    lambda do
      node.send :handle_response do
        RestClient::Response.create 'false', nil, nil
      end
    end.should raise_error(
      FbGraph::NotFound,
      'Graph API returned false, so probably it means your requested object is not found.'
    )
  end
end