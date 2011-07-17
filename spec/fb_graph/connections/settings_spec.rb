require 'spec_helper'

describe FbGraph::Connections::Settings do
  context 'when all settings enabled' do
    before do
      mock_graph :get, 'all_enabled/settings', 'pages/settings/all_enabled', :access_token => 'page_token' do
        @page = FbGraph::Page.new('all_enabled', :access_token => 'page_token')
        @page.settings # cache settings
      end
    end

    FbGraph::Connections::Settings::AVAILABLE_SETTINGS.each do |setting|
      describe "##{setting}?" do
        it { @page.send(:"#{setting}?").should be_true }
      end
    end

    context 'when no_cache specified' do
      FbGraph::Connections::Settings::AVAILABLE_SETTINGS.each do |setting|
        describe "##{setting}?" do
          it 'should request API' do
            expect { @page.send(:"#{setting}?", :no_cache => true) }.should request_to 'all_enabled/settings'
          end
        end
      end
    end
  end

  describe '#settings' do
    subject do
      mock_graph :get, 'sample/settings', 'pages/settings/sample', :access_token => 'page_token' do
        FbGraph::Page.new('sample').settings(:access_token => 'page_token')
      end
    end

    it do
      should == [
        :users_can_post,
        :users_can_post_photos,
        :users_can_post_videos
      ]
    end
  end

  describe '#setting!' do
    
  end
end