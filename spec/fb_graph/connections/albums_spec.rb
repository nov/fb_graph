require File.join(File.dirname(__FILE__), '../../spec_helper')

describe FbGraph::Connections::Albums, '#albums' do
  context 'when included by FbGraph::User' do
    before(:all) do
      fake_json(:get, 'matake/albums', 'users/albums/matake_public')
      fake_json(:get, 'matake/albums?access_token=access_token', 'users/albums/matake_private')
    end

    context 'when no access_token given' do
      it 'should raise FbGraph::Unauthorized' do
        lambda do
          FbGraph::User.new('matake').albums
        end.should raise_exception(FbGraph::Unauthorized)
      end
    end

    context 'when access_token is given' do
      it 'should return albums as FbGraph::Album' do
        albums = FbGraph::User.new('matake', :access_token => 'access_token').albums
        albums.first.should == FbGraph::Album.new(
          '19351532276',
          :from => {
            :id => '579612276',
            :name => 'Nov Matake'
          },
          :name => 'モバイルアップロード',
          :link => 'http://www.facebook.com/album.php?aid=25463&id=579612276',
          :count => 3,
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