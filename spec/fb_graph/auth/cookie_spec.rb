require 'spec_helper'

describe FbGraph::Auth::Cookie, '.parse' do
  let(:client) { Rack::OAuth2::Client.new(:identifier => 'client_id', :secret => 'client_secret') }
  let :cookie do
    {
      'fbsr_client_id' => "9heZHFs6tDH/Nif4CqmBaMQ8nKEOc5g2WgVJa10LF00.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImNvZGUiOiI4ZDYwZDY4NDA4MmQ1NjczMjY3MWUxNzAuMS01Nzk2MTIyNzZ8N2pkVlp6MlNLNUY2b0gtQ21FQWtZZVpuVjEwIiwiaXNzdWVkX2F0IjoxMzEyOTUzOTcxLCJ1c2VyX2lkIjo1Nzk2MTIyNzZ9"
    }
  end

  shared_examples_for :parsable_cookie do
    it 'should be parsable' do
      data[:algorithm].should == 'HMAC-SHA256'
      data[:code].should      == '8d60d684082d56732671e170.1-579612276|7jdVZz2SK5F6oH-CmEAkYeZnV10'
      data[:issued_at].should == 1312953971
      data[:user_id].should   == 579612276
    end
  end

  context 'when whole cookie is given' do
    let(:data) { FbGraph::Auth::Cookie.parse(client, cookie) }
    it_behaves_like :parsable_cookie
  end

  context 'when actual cookie string is given' do
    let(:data) { FbGraph::Auth::Cookie.parse(client, cookie['fbsr_client_id']) }
    it_behaves_like :parsable_cookie
  end
end
