require 'spec_helper'

describe FbGraph::Auth::Cookie, '.parse' do
  before do
    @client = Rack::OAuth2::Client.new(:identifier => 'client_id', :secret => 'client_secret')
    @cookie = {
      'fbs_client_id' => "access_token=t&expires=0&secret=s&session_key=k&sig=f4bae8ec88ba11440e3bdcc1bcf78317&uid=12345"
    }
  end

  it 'should parse fbs_APP_ID cookie' do
    cookie = FbGraph::Auth::Cookie.parse(@client, @cookie)
    cookie[:access_token].should == 't'
    cookie[:expires].should      == 0
    cookie[:secret].should       == 's'
    cookie[:session_key].should  == 'k'
    cookie[:uid].should          == '12345'
  end
end
