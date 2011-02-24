require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Node, '.new' do

  it 'should setup endpoint' do
    FbGraph::Node.new('matake').endpoint.should == File.join(FbGraph::ROOT_URL, 'matake')
  end

  it 'should support access_token option' do
    FbGraph::Node.new('matake', :access_token => 'access_token').access_token.should == 'access_token'
  end

end

describe FbGraph::Node, '#stringfy_params' do
  let :client do
    OAuth2::Client.new('client_id', 'client_secret')
  end

  it 'should make all values to JSON' do
    node = FbGraph::Node.new('identifier')
    params = node.send :stringfy_params, {:hash => {:a => :b}, :array => [:a, :b]}
    params[:hash].should == '{"a":"b"}'
    params[:array].should == '["a","b"]'
  end

  it 'should support OAuth2::AccessToken as self.access_token' do
    node = FbGraph::Node.new('identifier', :access_token => OAuth2::AccessToken.new(client, 'token', 'secret'))
    params = node.send :stringfy_params, {}
    params[:access_token].should == 'token'
  end

  it 'should support OAuth2::AccessToken as options[:access_token]' do
    node = FbGraph::Node.new('identifier')
    params = node.send :stringfy_params, {:access_token => OAuth2::AccessToken.new(client, 'token', 'secret')}
    params[:access_token].should == 'token'
  end
end

describe FbGraph::Node, '#handle_response' do
  let :node do
    FbGraph::Node.new('identifier')
  end

  let :null_response do
    HTTP::Message.new_response('null')
  end

  let :false_response do
    HTTP::Message.new_response('false')
  end

  it 'should handle null/false response' do
    node.send :handle_response do
      null_response
    end.should be_nil
    lambda do
      node.send :handle_response do
        false_response
      end
    end.should raise_error(
      FbGraph::NotFound,
      'Graph API returned false, so probably it means your requested object is not found.'
    )
  end
end