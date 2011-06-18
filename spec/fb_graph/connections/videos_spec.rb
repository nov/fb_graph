require 'spec_helper'

describe FbGraph::Connections::Videos do
  describe '#videos' do
    it 'should return videos as FbGraph::Video' do
      mock_graph :get, 'kirk/videos', 'users/videos/kirk_private', :access_token => 'access_token' do
        videos = FbGraph::User.new('kirk', :access_token => 'access_token').videos
        videos.each do |video|
          video.should be_instance_of(FbGraph::Video)
        end
      end
    end
  end

  describe '#video!' do
    it 'should return generated photo' do
      mock_graph :post, 'me/videos', 'users/videos/posted' do
        me = FbGraph::User.me('access_token')
        video = me.video!(
          :source => Tempfile.new('movie_file')
        )
        video.should be_a FbGraph::Video
        video.identifier.should == '10150241488822277'
      end
    end
  end
end