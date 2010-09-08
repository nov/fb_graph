require File.join(File.dirname(__FILE__), '../../spec_helper')

context 'when included by FbGraph::Application' do
  describe FbGraph::Connections::Subscriptions, '#subscriptions' do
    before(:all) do
      fake_json(:get, 'fb_graph/subscriptions?access_token=access_token', 'applications/subscriptions/fb_graph_private')
    end

    context 'when access_token is given' do
      it 'should return liked pages as FbGraph::Page' do
        subscriptions = FbGraph::Application.new('fb_graph', :access_token => 'access_token').subscriptions
        subscriptions.each do |subscription|
          subscription.should be_instance_of(FbGraph::Subscription)
        end
      end
    end
  end
end