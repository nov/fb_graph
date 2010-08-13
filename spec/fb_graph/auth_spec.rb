require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Auth, '.new' do

  it 'should setup OAuth2::Client' do
    auth = FbGraph::Auth.new('client_id', 'client_secret')
    auth.client.should be_a(OAuth2::Client)
    auth.client.id.should            == 'client_id'
    auth.client.secret.should == 'client_secret'
  end

  context 'when invalid cookie given' do
    it 'should raise FbGraph::VerificationFailed' do
      lambda do
        FbGraph::Auth.new('client_id', 'client_secret', :cookie => 'invalid')
      end.should raise_exception(FbGraph::Auth::VerificationFailed)
    end
  end

end

describe FbGraph::Auth, '.from_cookie' do
  before do
    @auth = FbGraph::Auth.new('client_id', 'client_secret')
  end

  context 'when invalid cookie given' do
    it 'should raise FbGraph::VerificationFailed' do
      lambda do
        @auth.from_cookie('invalid')
      end.should raise_exception(FbGraph::Auth::VerificationFailed)
    end
  end

end