require 'spec_helper'

describe FbGraph::Connections::Subscriptions, '#subscriptions' do
  context 'when included by FbGraph::Application' do
    context 'when access_token is given' do
      it 'should return liked pages as FbGraph::Page' do
        mock_graph :get, 'fb_graph/subscriptions', 'applications/subscriptions/fb_graph_private', :access_token => 'access_token' do
          subscriptions = FbGraph::Application.new('fb_graph', :access_token => 'access_token').subscriptions
          subscriptions.each do |subscription|
            subscription.should be_instance_of(FbGraph::Subscription)
          end
        end
      end
    end
  end
end

describe FbGraph::Connections::Subscriptions, '#subscribe!' do
  before do
    @app = FbGraph::Application.new('fb_graph', :access_token => 'access_token')
  end

  it 'should POST to /:app_id/subscriptions' do
    lambda do
      @app.subscribe!(
        :object => "user",
        :fields => "name,email",
        :callback_url => "http://fbgraphsample.heroku.com/subscription",
        :verify_token => "Define by yourself"
      )
    end.should request_to 'fb_graph/subscriptions', :post
  end
end

describe FbGraph::Connections::Subscriptions, '#unsubscribe!' do
  before do
    @app = FbGraph::Application.new('fb_graph', :access_token => 'access_token')
  end

  it 'should DELETE /:app_id/subscriptions' do
    mock_graph :delete, 'fb_graph/subscriptions', 'true', :params => {:object => 'user'}, :access_token => 'access_token' do
      @app.unsubscribe!(
        :object => 'user'
      )
    end
  end
end