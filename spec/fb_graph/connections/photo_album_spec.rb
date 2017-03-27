require 'spec_helper'

describe FbGraph::Connections::PhotoAlbum do
  describe FbGraph::Post, '#album' do
    it 'should be nil if link does not contains set parameter in query string' do
      photo_post = FbGraph::Post.new('12345', :type => 'photo', :link => "http://www.facebook.com/579612276/posts/10150089741782277")
      photo_post.album.should be_nil
    end

    it 'should contain an FbGraph::Album object if link contains set parameter in query string' do
      photo_post = FbGraph::Post.new('12345', :type => 'photo', :link => "https://www.facebook.com/photo.php?fbid=482953695129869&set=a.482060835219155.1073741853.325091900916050&type=1&relevant_count=62")
      photo_post.album.should == FbGraph::Album.new("482060835219155")
    end
  end

  describe FbGraph::Photo, '#album' do
    it 'should be nil if link does not contains set parameter in query string' do
      photo = FbGraph::Photo.new('12345', :link => "http://www.facebook.com/579612276/posts/10150089741782277")
      photo.album.should be_nil
    end

    it 'should contain an FbGraph::Album object if link contains set parameter in query string' do
      photo = FbGraph::Photo.new('12345', :link => "https://www.facebook.com/photo.php?fbid=482953695129869&set=a.482060835219155.1073741853.325091900916050&type=1&relevant_count=62")
      photo.album.should == FbGraph::Album.new("482060835219155")
    end
  end
end