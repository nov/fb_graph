require 'spec_helper'

describe FbGraph::Connections::AppNotifications do
  let(:app) do
    _app_ = FbGraph::Application.new('app_id', :secret => 'app_secret')
    _app_.should_receive(:get_access_token).and_return(
      Rack::OAuth2::AccessToken::Legacy.new(:access_token => 'app_access_token')
    )
    _app_
  end

  describe '#notify!' do
    it 'should return success json' do
      mock_graph :post, 'matake/notifications', 'success', :params => {
        :template => 'hello'
      }, :access_token => 'app_access_token' do
        user = FbGraph::User.new('matake')
        response = app.notify! user, :template => 'hello'
        response.should == {'success' => true}
      end
    end
  end
end