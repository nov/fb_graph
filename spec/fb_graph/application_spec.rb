require 'spec_helper'

describe FbGraph::Application, '.new' do
  it 'should setup all supported attributes' do
    attributes = {
      :id          => '12345',
      :name        => 'FbGraph',
      :description => 'Owsome Facebook Graph Wrapper',
      :category    => 'Programming',
      :link        => 'http://github.com/nov/fb_graph',
      :secret      => 'sec sec'
    }
    app = FbGraph::Application.new(attributes.delete(:id), attributes)
    app.identifier.should  == '12345'
    app.name.should        == 'FbGraph'
    app.description.should == 'Owsome Facebook Graph Wrapper'
    app.category.should    == 'Programming'
    app.link.should        == 'http://github.com/nov/fb_graph'
    app.secret.should      == 'sec sec'
  end
end

describe FbGraph::Application, '.get_access_token' do
  before do
    fake_json :post, 'oauth/access_token', 'token_response'
    @app = FbGraph::Application.new('client_id', :secret => 'client_secret')
  end

  it 'should POST oauth/token' do
    @app.access_token.should be_nil
    @app.get_access_token
    @app.access_token.should be_instance_of(Rack::OAuth2::AccessToken::Legacy)
    @app.access_token.access_token.should == 'token'
  end

  after do
    FakeWeb.clean_registry
  end
end