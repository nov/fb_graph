require 'spec_helper'

describe FbGraph::Application do
  let(:app) { FbGraph::Application.new('client_id') }

  describe '.new' do
    it 'should setup all supported attributes' do
      attributes = {
        :id          => '12345',
        :name        => 'FbGraph',
        :description => 'Owsome Facebook Graph Wrapper',
        :canvas_name => 'fb_graph',
        :category    => 'Programming',
        :subcategory => 'Ruby',
        :link        => 'http://github.com/nov/fb_graph',
        :company     => 'FbGraph',
        :secret      => 'sec sec',
        :icon_url    => 'http://example.com/icon.gif',
        :logo_url    => 'http://example.com/logo.gif',
        :daily_active_users => '10',
        :weekly_active_users => '5',
        :monthly_active_users => '1',
        :migrations => {
          'secure_stream_urls' => false,
          'expiring_offline_access_tokens' => true,
          'december_rollup' => true,
          'requires_login_secret' => false,
          'gdp_v2' => true,
          'page_hours_format' => true,
          'graph_batch_api_exception_format' => true,
          'status_checkin_perm_migration' => false
        },
        :namespace => 'fb_graph',
        :restrictions => {
          'age_distribution' => {
            'CA,US' => '16-25'
          }
        },
        :app_domains => [
          'example.com',
          'example.org'
        ],
        :auth_dialog_data_help_url => 'http://example.com/help/',
        :auth_dialog_description => 'Authorize this app',
        :auth_dialog_headline => "Don't think, just click",
        :auth_dialog_perms_explanation => 'Trust me',
        :auth_referral_user_perms => [
          'user_hometown',
          'user_activities',
          'user_online_presence'
        ],
        :auth_referral_default_activity_privacy => 'NONE',
        :auth_referral_enabled => 1,
        :auth_referral_extended_perms => [
          'status_update',
          'video_upload',
          'publish_stream'
        ],
        :auth_referral_response_type => 'code',
        :canvas_fluid_height => false,
        :canvas_fluid_width => 1,
        :canvas_url => 'http://example.com/canvas/',
        :contact_email => 'fb_graph@example.com',
        :created_time => 1328798126,
        :creator_uid => 98765,
        :deauth_callback_url => 'http://example.com/death/',
        :iphone_app_store_id => '4567',
        :hosting_url => 'http://fb_graph.heroku.com',
        :mobile_web_url => 'http://m.example.com',
        :page_tab_default_name => 'fb_graph Page',
        :page_tab_url => 'http://example.com/page/',
        :privacy_policy_url => 'http://example.com/privacy/',
        :secure_canvas_url => 'https://example.com/canvas/',
        :secure_page_tab_url => 'https://example.com/page/',
        :server_ip_whitelist => '127.0.0.1',
        :social_discovery => 0,
        :terms_of_service_url => 'http://example.com/terms/',
        :user_support_email => 'fb_graph@example.org',
        :user_support_url => 'http://example.com/support/',
        :website_url => 'http://example.com',
        :type => 'application'
      }

      app = FbGraph::Application.new(attributes.delete(:id), attributes)
      app.identifier.should  == '12345'
      app.name.should        == 'FbGraph'
      app.description.should == 'Owsome Facebook Graph Wrapper'
      app.canvas_name.should == 'fb_graph'
      app.category.should    == 'Programming'
      app.subcategory.should == 'Ruby'
      app.link.should        == 'http://github.com/nov/fb_graph'
      app.company.should     == 'FbGraph'
      app.icon_url.should    == 'http://example.com/icon.gif'
      app.logo_url.should    == 'http://example.com/logo.gif'
      app.secret.should      == 'sec sec'
      app.daily_active_users.should == 10
      app.weekly_active_users.should == 5
      app.monthly_active_users.should == 1
      app.migrations.should == {
        'secure_stream_urls' => false,
        'expiring_offline_access_tokens' => true,
        'december_rollup' => true,
        'requires_login_secret' => false,
        'gdp_v2' => true,
        'page_hours_format' => true,
        'graph_batch_api_exception_format' => true,
        'status_checkin_perm_migration' => false
      }
      app.namespace.should == 'fb_graph'
      app.restrictions.should == {
        'age_distribution' => {
          'CA,US' => '16-25'
        }
      }
      app.app_domains.should == [
        'example.com',
        'example.org'
      ]
      app.auth_dialog_data_help_url.should == 'http://example.com/help/'
      app.auth_dialog_description.should == 'Authorize this app'
      app.auth_dialog_headline.should == "Don't think, just click"
      app.auth_dialog_perms_explanation.should == 'Trust me'
      app.auth_referral_user_perms.should == [
        'user_hometown',
        'user_activities',
        'user_online_presence'
      ]
      app.auth_referral_default_activity_privacy.should == 'NONE'
      app.auth_referral_enabled.should == true
      app.auth_referral_extended_perms.should == [
        'status_update',
        'video_upload',
        'publish_stream'
      ]
      app.auth_referral_response_type.should == 'code'
      app.canvas_fluid_height.should == false
      app.canvas_fluid_width.should == true
      app.canvas_url.should == 'http://example.com/canvas/'
      app.contact_email.should == 'fb_graph@example.com'
      app.created_time.should == 1328798126
      app.creator_uid.should == 98765
      app.deauth_callback_url.should == 'http://example.com/death/'
      app.iphone_app_store_id.should == '4567'
      app.hosting_url.should == 'http://fb_graph.heroku.com'
      app.mobile_web_url.should == 'http://m.example.com'
      app.page_tab_default_name.should == 'fb_graph Page'
      app.page_tab_url.should == 'http://example.com/page/'
      app.privacy_policy_url.should == 'http://example.com/privacy/'
      app.secure_canvas_url.should == 'https://example.com/canvas/'
      app.secure_page_tab_url.should == 'https://example.com/page/'
      app.server_ip_whitelist.should == '127.0.0.1'
      app.social_discovery.should == false
      app.user_support_email.should == 'fb_graph@example.org'
      app.user_support_url.should == 'http://example.com/support/'
      app.website_url.should == 'http://example.com'
      app.type.should == 'application'
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

  describe '#debug_token' do
    before { app.access_token = 'app_token' }
    let(:application) { FbGraph::Application.new(210798282372757, :name => 'gem sample') }
    let(:user)        { FbGraph::User.new(579612276) }
    let(:scopes)      { ['email'] }

    shared_examples_for :token_debugger do
      context 'when valid' do
        it 'should return introspection result without error' do
          mock_graph :get, 'debug_token', 'token_introspection/valid', :access_token => 'app_token', :params => {
            :input_token => 'input_token'
          } do
            result = app.debug_token input_token
            result.should be_instance_of Rack::OAuth2::AccessToken::Introspectable::Result
            result.application.should == application
            result.user.should == user
            result.scopes.should == scopes
            result.expires_at.should == Time.at(1350363600)
            result.is_valid.should be_true
            result.error.should be_nil
          end
        end
      end

      context 'when invalid' do
        it 'should return introspection result with error' do
          mock_graph :get, 'debug_token', 'token_introspection/invalid', :access_token => 'app_token', :params => {
            :input_token => 'input_token'
          } do
            result = app.debug_token input_token
            result.should be_instance_of Rack::OAuth2::AccessToken::Introspectable::Result
            result.application.should == application
            result.user.should == user
            result.scopes.should == scopes
            result.expires_at.should == Time.at(1350356400)
            result.is_valid.should be_false
            result.error.should be_a Hash
          end
        end
      end
    end

    context 'when input_token is String' do
      let(:input_token) { 'input_token' }
      it_behaves_like :token_debugger
    end

    context 'when input_token is Rack::OAuth2::AccessToken::Legacy instance' do
      let(:input_token) { Rack::OAuth2::AccessToken::Legacy.new :access_token => 'input_token' }
      it_behaves_like :token_debugger
    end
  end

  describe '#reviews' do
    it 'gets the reviews for this application' do
      mock_graph :get, 'client_id/reviews', 'applications/reviews' do
        app_reviews = app.reviews
        app_reviews.count.should == 25
        app_reviews.first.identifier.should == '10150351582136960'
      end
    end
  end
end
