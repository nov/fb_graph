require 'spec_helper'

describe FbGraph::Connections::Notifications do
  describe '#notifications' do
    it 'should return notifications as FbGraph::Notification' do
      mock_graph :get, 'me/notifications', 'users/notifications/all', :params => {
        :include_read => 'true'
      }, :access_token => 'access_token' do
        notifications = FbGraph::User.me('access_token').notifications(:include_read => true)
        notifications.each do |notification|
          notification.should be_instance_of FbGraph::Notification
        end
      end
    end
  end
end
