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
  let(:app) { FbGraph::Application.new('client_id', :secret => 'client_secret') }
  it 'should return Rack::OAuth2::AccessToken::Legacy' do
    mock_graph :post, 'oauth/access_token', 'token_response' do
      app.access_token.should be_nil
      app.get_access_token
      app.access_token.should be_instance_of(Rack::OAuth2::AccessToken::Legacy)
      app.access_token.access_token.should == 'token'
    end
  end
end