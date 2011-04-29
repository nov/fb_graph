require 'spec_helper'

describe FbGraph::Connections::Videos, '#videos' do
  it 'should return videos as FbGraph::Video' do
    mock_graph :get, 'kirk/videos', 'users/videos/kirk_private', :params => {
      :access_token => 'access_token'
    } do
      videos = FbGraph::User.new('kirk', :access_token => 'access_token').videos
      videos.each do |video|
        video.should be_instance_of(FbGraph::Video)
      end
    end
  end
end