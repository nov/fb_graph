# -*- coding: utf-8 -*-
require 'spec_helper'

describe FbGraph::Connections::Activities, '#activities' do
  context 'when included by FbGraph::User' do
    context 'when no access_token given' do
      it 'should raise FbGraph::Unauthorized' do
        mock_graph :get, 'arjun/activities', 'users/activities/arjun_public', :status => [401, 'Unauthorized'] do
          lambda do
            FbGraph::User.new('arjun').activities
          end.should raise_exception(FbGraph::Unauthorized)
        end
      end
    end

    context 'when access_token is given' do
      it 'should return activities as FbGraph::Page' do
        mock_graph :get, 'arjun/activities', 'users/activities/arjun_private', :access_token => 'access_token' do
          activities = FbGraph::User.new('arjun', :access_token => 'access_token').activities
          activities.class.should == FbGraph::Connection
          activities.first.should == FbGraph::Page.new(
            '378209722137',
            :access_token => 'access_token',
            :name => 'Doing Things at the Last Minute',
            :category => '活動'
          )
          activities.each do |activity|
            activity.should be_instance_of(FbGraph::Page)
          end
        end
      end
    end
  end
end
