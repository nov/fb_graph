require 'spec_helper'

describe FbGraph::Connections::Settings do

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

  describe 'setting specific methods' do
    let(:page) { FbGraph::Page.new('page_id', :access_token => 'page_token') }

    before do
      mock_graph :get, 'page_id/settings', 'pages/settings/all_enabled', :access_token => 'page_token' do
        page.settings # cache settings
      end
    end

    FbGraph::Connections::Settings::AVAILABLE_SETTINGS.each do |setting|
      describe "##{setting}?" do
        it { page.send(:"#{setting}?").should be_true }

        context 'when no_cache specified' do
          it 'should request API' do
            expect { page.send(:"#{setting}?", :no_cache => true) }.to request_to 'page_id/settings'
          end
        end
      end

      describe "#{setting}!" do
        it "should enable it" do
          mock_graph :post, 'page_id/settings', 'true', :access_token => 'page_token', :params => {
            :setting => setting.to_s.upcase, :value => 'true'
          } do
            page.send(:"#{setting}!").should be_true
          end
        end
      end

      describe "#{setting.to_s.sub('can', 'cannot')}!" do
        it "should disable it" do
          mock_graph :post, 'page_id/settings', 'true', :access_token => 'page_token', :params => {
            :setting => setting.to_s.upcase, :value => 'false'
          } do
            page.send(:"#{setting.to_s.sub('can', 'cannot')}!").should be_true
          end
        end
      end
    end
  end
end