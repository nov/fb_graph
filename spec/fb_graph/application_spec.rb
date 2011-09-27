require 'spec_helper'

describe FbGraph::Application do
  let(:app) { FbGraph::Application.new('client_id') }

  describe '.new' do
    it 'should setup all supported attributes' do
      attributes = {
        :id          => '12345',
        :name        => 'FbGraph',
        :description => 'Owsome Facebook Graph Wrapper',
        :category    => 'Programming',
        :link        => 'http://github.com/nov/fb_graph',
        :secret      => 'sec sec',
        :daily_active_users => '10'
      }
      app = FbGraph::Application.new(attributes.delete(:id), attributes)
      app.identifier.should  == '12345'
      app.name.should        == 'FbGraph'
      app.description.should == 'Owsome Facebook Graph Wrapper'
      app.category.should    == 'Programming'
      app.link.should        == 'http://github.com/nov/fb_graph'
      app.secret.should      == 'sec sec'
      app.daily_active_users.should == 10
    end
  end

  describe '#get_access_token' do
    before { app.secret = 'secret' }

    it 'should return Rack::OAuth2::AccessToken::Legacy' do
      mock_graph :post, 'oauth/access_token', 'token_response' do
        token = app.get_access_token
        token.should be_instance_of(Rack::OAuth2::AccessToken::Legacy)
        token.access_token.should == 'token'
      end
    end
  end

  describe '#access_token' do
    context 'when access token already exists' do
      before { app.access_token = "token" }
      it 'should not fetch new token' do
        app.should_not_receive(:get_access_token)
        app.access_token
      end
    end

    context 'otherwise' do
      context 'when secret exists' do
        before { app.secret = 'secret' }
        it 'should fetch new token' do
          app.should_receive(:get_access_token)
          app.access_token
        end
      end

      context 'otherwise' do
        it 'should not fetch new token' do
          app.should_not_receive(:get_access_token)
          app.access_token
        end
      end
    end
  end
end