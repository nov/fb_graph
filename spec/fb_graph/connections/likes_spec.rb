# -*- coding: utf-8 -*-
require 'spec_helper'

describe FbGraph::Connections::Likes do
  describe '#likes' do
    context 'when included by FbGraph::User' do
      context 'when no access_token given' do
        it 'should raise FbGraph::Unauthorized' do
          mock_graph :get, 'arjun/likes', 'users/likes/arjun_public', :status => [401, 'Unauthorized'] do
            lambda do
              FbGraph::User.new('arjun').likes
            end.should raise_exception(FbGraph::Unauthorized)
          end
        end
      end

      context 'when access_token is given' do
        it 'should return liked pages as FbGraph::Page' do
          mock_graph :get, 'arjun/likes', 'users/likes/arjun_private', :access_token => 'access_token' do
            likes = FbGraph::User.new('arjun', :access_token => 'access_token').likes
            likes.first.should == FbGraph::Page.new(
              '378209722137',
              :access_token => 'access_token',
              :name => 'Doing Things at the Last Minute',
              :category => '活動'
            )
            likes.each do |like|
              like.should be_instance_of(FbGraph::Page)
            end
          end
        end
      end
    end

    context 'when included by FbGraph::Status' do
      context 'when cached collection exists' do
        before do
          mock_graph :get, 'with_likes', 'statuses/with_likes', :access_token => 'access_token' do
            @status = FbGraph::Status.new('with_likes').fetch(:access_token => 'access_token')
          end
        end

        context 'when no options given' do
          it 'should not access to Graph API' do
            @status.likes.should == [FbGraph::User.new(
              '604578140',
              :access_token => 'access_token',
              :name => 'K Hiromi'
            )]
            @status.likes.next.should == []
            @status.likes.previous.should == []
          end
        end

        context 'when any options given' do
          it 'should access to Graph API' do
            lambda do
              @status.likes(:no_cache => true) # :no_cache has no meaning, just putting some value as options
            end.should request_to('115838235152172/likes?access_token=access_token&no_cache=true')
            lambda do
              @status.likes(:limit => 10)
            end.should request_to('115838235152172/likes?access_token=access_token&limit=10')
          end

          context 'when next/previous are obviously blank' do
            it 'should not access to Graph API' do
              @status.likes.next(:no_cache => true).should == []
              @status.likes.previous(:no_cache => true).should == []
            end
          end
        end
      end
    end
  end

  describe '#like?' do
    let(:user)     { FbGraph::User.new(579612276, :access_token => 'access_token') }
    let(:fb_graph) { FbGraph::Page.new(117513961602338) }
    let(:poken)    { FbGraph::Page.new(1234567890) }

    context 'when liked' do
      it 'should retrun true' do
        mock_graph :get, '579612276/likes/117513961602338', 'users/likes/fb_graph', :access_token => 'access_token' do
          user.like?(fb_graph).should be_true
        end
      end
    end

    context 'otherwise' do
      it 'should retrun true' do
        mock_graph :get, '579612276/likes/1234567890', 'users/likes/poken', :access_token => 'access_token' do
          user.like?(poken).should be_false
        end
      end
    end
  end
end