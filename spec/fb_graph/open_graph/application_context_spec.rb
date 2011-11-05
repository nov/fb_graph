require 'spec_helper'

describe FbGraph::OpenGraph::ApplicationContext do
  let :application_with_namespace do
    FbGraph::Application.new('app_id', :namespace => 'fbgraph')
  end
  let :application_without_namespace do
    FbGraph::Application.new('app_id')
  end

  describe '#og_action' do
    context 'with namespace' do
      it 'should return "APP_NAMESPACE:ACTION_NAME" without fetching application info' do
        application_with_namespace.og_action('action_name').should == 'fbgraph:action_name'
        application_with_namespace.og_action(:action_name).should == 'fbgraph:action_name'
      end
    end

    context 'without namespace' do
      it 'should return "APP_NAMESPACE:ACTION_NAME" with fetching application info' do
        mock_graph :get, 'app_id', 'applications/fbgraphsample' do
          application_without_namespace.og_action('action_name').should == 'fbgraphsample:action_name'
          application_without_namespace.og_action(:action_name).should == 'fbgraphsample:action_name'
        end
      end
    end
  end
end