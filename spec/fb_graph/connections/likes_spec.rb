# -*- coding: utf-8 -*-
require 'spec_helper'

describe FbGraph::Connections::Likes do
  describe '#likes' do
    context 'when liked by a Page' do
      it 'should handle the liker as a Page' do
        mock_graph :get, 'post_id', 'posts/liked_by_page', :access_token => 'access_token' do
          post = FbGraph::Post.new('post_id').fetch(:access_token => 'access_token')
          post.likes.first.should be_instance_of FbGraph::Page
        end
      end
    end

    context 'when included by FbGraph::Post' do
      let(:post) { FbGraph::Post.new('post_id', :access_token => 'access_token', :likes => {}) }

      describe 'cached likes' do
        context 'when cached' do
          it 'should use cache' do
            lambda do
              post.likes
            end.should_not request_to 'post_id/likes?access_token=access_token'
          end

          context 'when options are specified' do
            it 'should not use cache' do
              lambda do
                post.likes(:no_cache => true)
              end.should request_to 'post_id/likes?access_token=access_token&no_cache=true'
            end
          end
        end

        context 'otherwise' do
          let(:post) { FbGraph::Post.new(12345, :access_token => 'access_token') }

          it 'should not use cache' do
            lambda do
              post.likes
            end.should request_to '12345/likes?access_token=access_token'
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

  describe '#like!' do
    context 'when included by FbGraph::Post' do
      context 'when no access_token given' do
        it 'should raise FbGraph::Exception' do
          mock_graph :post, '12345/likes', 'posts/likes/post_without_access_token', :status => [500, 'Internal Server Error'] do
            lambda do
              FbGraph::Post.new('12345').like!
            end.should raise_exception(FbGraph::Exception)
          end
        end
      end

      context 'when invalid access_token is given' do
        it 'should raise FbGraph::Exception' do
          mock_graph :post, '12345/likes', 'posts/likes/post_with_invalid_access_token', :status => [500, 'Internal Server Error'] do
            lambda do
              FbGraph::Post.new('12345', :access_token => 'invalid').like!
            end.should raise_exception(FbGraph::Exception)
          end
        end
      end

      context 'when valid access_token is given' do
        it 'should return true' do
          mock_graph :post, '12345/likes', 'posts/likes/post_with_valid_access_token' do
            FbGraph::Post.new('12345', :access_token => 'valid').like!.should be_true
          end
        end
      end
    end
  end

  describe '#unlike!' do
    it 'should DELETE /:object_id/likes' do
      mock_graph :delete, '12345/likes', 'true', :access_token => 'valid' do
        FbGraph::Post.new('12345', :access_token => 'valid').unlike!
      end
    end
  end
end