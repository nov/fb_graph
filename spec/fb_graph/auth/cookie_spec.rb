require 'spec_helper'

describe FbGraph::Auth::Cookie, '.parse' do
  before do
    @client = Rack::OAuth2::Client.new(:identifier => 'client_id', :secret => 'client_secret')
    @cookie = {
      'fbs_client_id' => "access_token=t&expires=0&secret=s&session_key=k&sig=f4bae8ec88ba11440e3bdcc1bcf78317&uid=12345"
    }
  end

  shared_examples_for :parsable_cookie do
    it 'should be parsable' do
      cookie[:access_token].should == 't'
      cookie[:expires].should      == 0
      cookie[:secret].should       == 's'
      cookie[:session_key].should  == 'k'
      cookie[:uid].should          == '12345'
    end
  end

  context 'when whole cookie is given' do
    let(:cookie) { FbGraph::Auth::Cookie.parse(@client, @cookie) }
    it_behaves_like :parsable_cookie
  end

  context 'when actual cookie string is given' do
    let(:cookie) { FbGraph::Auth::Cookie.parse(@client, @cookie['fbs_client_id']) }
    it_behaves_like :parsable_cookie
  end
end
