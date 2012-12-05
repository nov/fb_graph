require 'spec_helper'

describe FbGraph::Album do
  describe '.new' do
    it 'should setup all supported attributes' do
      attributes = {
        :id => '12345',
        :from => {
          :id => '23456',
          :name => 'nov matake'
        },
        :name => 'album 1',
        :description => 'an album for fb_graph test',
        :location => 'Tokyo, Japan',
        :link => 'http://www.facebook.com/album/12345',
        :count => 10,
        :cover_photo => '10150146072661729',
        :type => 'normal',
        :created_time => '2009-12-29T15:24:50+0000',
        :updated_time => '2010-01-02T15:37:41+0000',
        :comments => {
          :data => [{
            :id => '909694472945_418735',
            :from => {
              :id => '520739622',
              :name => 'Alison Marie Weber',
            },
            :message => 'Love all the pix!',
            :created_time => '2009-08-15T14:57:36+0000'
          }]
        }
      }
      album = FbGraph::Album.new(attributes.delete(:id), attributes)
      album.identifier.should     == '12345'
      album.from.should           == FbGraph::User.new('23456', :name => 'nov matake')
      album.name.should           == 'album 1'
      album.description.should    == 'an album for fb_graph test'
      album.location.should       == 'Tokyo, Japan'
      album.link.should           == 'http://www.facebook.com/album/12345'
      album.cover_photo.should    == FbGraph::Photo.new('10150146072661729')
      album.count.should          == 10
      album.type.should           == 'normal'
      album.created_time.should   == Time.parse('2009-12-29T15:24:50+0000')
      album.updated_time.should   == Time.parse('2010-01-02T15:37:41+0000')
      album.comments.should       == [FbGraph::Comment.new(
        '909694472945_418735',
        :from => {
          :id => '520739622',
          :name => 'Alison Marie Weber',
        },
        :message => 'Love all the pix!',
        :created_time => '2009-08-15T14:57:36+0000'
      )]
    end

    it 'should support page as from' do
      page_album = FbGraph::Album.new('12345', :from => {
        :id => '23456',
        :name => 'Smart.fm',
        :category => 'Web Site'
      })
      page_album.from.should == FbGraph::Page.new('23456', :name => 'Smart.fm', :category => 'Web Site')
    end
  end

  describe '#picture' do
    let(:album) { FbGraph::Album.new('12345') }
    subject { album.picture }

    context 'when access token is given' do
      before { album.access_token = 'access_token' }
      it { should == File.join(FbGraph::ROOT_URL, '12345/picture?access_token=access_token') }
      it 'should support size' do
        album.picture(:small).should == File.join(FbGraph::ROOT_URL, '12345/picture?type=small&access_token=access_token')
      end
    end

    context 'when no access token' do
      it { should == File.join(FbGraph::ROOT_URL, '12345/picture') }
    end

    context 'when no redirect' do
      before { album.access_token = 'access_token' }
      it 'should return FbGraph::Picture' do
        mock_graph :get, '12345/picture', 'albums/picture/success', :access_token => 'access_token', :params => {
          :redirect => 'false'
        } do
          album.picture(:redirect => false).should be_instance_of FbGraph::Picture
        end
      end
    end
  end
end