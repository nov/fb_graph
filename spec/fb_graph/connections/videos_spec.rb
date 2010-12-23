require File.join(File.dirname(__FILE__), '../../spec_helper')

describe FbGraph::Connections::Videos, '#videos' do
  before do
    fake_json(:get, 'kirk/videos?access_token=access_token', 'users/videos/kirk_private')
  end

  it 'should return videos as FbGraph::Video' do
    videos = FbGraph::User.new('kirk', :access_token => 'access_token').videos
    videos.each do |video|
      video.should be_instance_of(FbGraph::Video)
    end
  end
end