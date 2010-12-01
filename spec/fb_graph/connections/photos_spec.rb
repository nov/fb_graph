require File.join(File.dirname(__FILE__), '../../spec_helper')

describe FbGraph::Connections::Photos, '#photos' do
  context 'when included by FbGraph::Album' do
    before(:all) do
      fake_json(:get, '12345/photos?access_token=access_token', 'albums/photos/matake_private')
    end

    it 'should return photos as FbGraph::Photo' do
      photos = FbGraph::Album.new('12345', :access_token => 'access_token').photos
      photos.each do |photo|
        photo.should be_instance_of(FbGraph::Photo)
      end
    end
  end
end

describe FbGraph::Connections::Photos, '#photo!' do
  before do
    fake_json(:post, '12345/photos', 'albums/photos/post_with_valid_access_token')
  end

  it 'should return generated photo' do
    photo = FbGraph::Album.new('12345', :access_token => 'valid').photo!(
      :image => Tempfile.new('image_file'),
      :message => 'Hello, where is photo?'
    )
    photo.identifier.should == 401111132276
    photo.name.should == 'Hello, where is photo?'
    photo.access_token.should == 'valid'
  end
end