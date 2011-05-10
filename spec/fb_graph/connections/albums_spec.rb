# -*- coding: utf-8 -*-
require 'spec_helper'

describe FbGraph::Connections::Albums, '#albums' do
  context 'when included by FbGraph::User' do
    context 'when no access_token given' do
      it 'should raise FbGraph::Unauthorized' do
        mock_graph :get, 'matake/albums', 'users/albums/matake_public', :status => [401, 'Unauthorized'] do
          lambda do
            FbGraph::User.new('matake').albums
          end.should raise_exception(FbGraph::Unauthorized)
        end
      end
    end

    context 'when access_token is given' do
      it 'should return albums as FbGraph::Album' do
        mock_graph :get, 'matake/albums', 'users/albums/matake_private', :access_token => 'access_token' do
          albums = FbGraph::User.new('matake', :access_token => 'access_token').albums
          albums.first.should == FbGraph::Album.new(
            '19351532276',
            :access_token => 'access_token',
            :from => {
              :id => '579612276',
              :name => 'Nov Matake'
            },
            :name => 'モバイルアップロード',
            :description => 'hello facebookers!',
            :link => 'http://www.facebook.com/album.php?aid=25463&id=579612276',
            :location => 'NYC',
            :count => 3,
            :privacy => 'everyone',
            :created_time => '2008-07-27T11:38:15+0000',
            :updated_time => '2009-02-07T16:09:53+0000'
          )
          albums.each do |album|
            album.should be_instance_of(FbGraph::Album)
          end
        end
      end
    end
  end
end

describe FbGraph::Connections::Albums, '#album!' do
  context 'when included by FbGraph::User' do
    it 'should return generated album' do
      mock_graph :post, 'matake/albums', 'users/albums/post_with_valid_access_token', :access_token => 'valid', :params => {
        :name => 'FbGraph test',
        :message => 'test test test'
      } do
        album = FbGraph::User.new('matake', :access_token => 'valid').album!(
          :name => 'FbGraph test',
          :message => 'test test test'
        )
        album.identifier.should == 401096332276
        album.access_token.should == 'valid'
        album.name.should == 'FbGraph test'
        album.description.should == 'test test test'
      end
    end
  end
end