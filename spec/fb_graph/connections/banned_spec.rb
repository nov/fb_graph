require 'spec_helper'

describe FbGraph::Connections::Banned do
  let(:app)  { FbGraph::Application.new('app_id', :secret => 'app_secret') }
  let(:user) { FbGraph::User.new('uid') }

  describe '#banned' do
    it 'should return an Array of FbGraph::User' do
      mock_graph :post, 'oauth/access_token', 'app_token_response' do
        mock_graph :get, 'app_id/banned', 'applications/banned/list', :access_token => 'app_token' do
          users = app.banned
          users.each do |user|
            user.should be_a FbGraph::User
          end
        end
      end
    end
  end

  describe '#banned?' do
    context 'when banned' do
      it 'should retrun true' do
        mock_graph :post, 'oauth/access_token', 'app_token_response' do
          mock_graph :get, 'app_id/banned/uid', 'applications/banned/banned_user', :access_token => 'app_token' do
            app.banned?(user).should be_true
          end
        end
      end
    end

    context 'otherwise' do
      it 'should retrun false' do
        mock_graph :post, 'oauth/access_token', 'app_token_response' do
          mock_graph :get, 'app_id/banned/uid', 'empty', :access_token => 'app_token' do
            app.banned?(user).should be_false
          end
        end
      end
    end
  end

  describe '#ban!' do
    it 'should return true' do
      mock_graph :post, 'oauth/access_token', 'app_token_response' do
        mock_graph :post, 'app_id/banned', 'true', :access_token => 'app_token', :params => {
          :uid => 'uid'
        } do
          app.ban!(user).should be_true
        end
      end
    end
  end

  describe '#unban!' do
    it 'should return true' do
      mock_graph :post, 'oauth/access_token', 'app_token_response' do
        mock_graph :delete, 'app_id/banned/uid', 'true', :access_token => 'app_token' do
          app.unban!(user).should be_true
        end
      end
    end
  end
end