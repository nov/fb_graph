require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Album, '#new' do

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
      :created_time => '2009-12-29T15:24:50+0000',
      :updated_time => '2010-01-02T15:37:41+0000'
    }
    album = FbGraph::Album.new(attributes.delete(:id), attributes)
    album.identifier.should   == '12345'
    album.from.should         == FbGraph::User.new('23456', :name => 'nov matake')
    album.name.should         == 'album 1'
    album.description.should  == 'an album for fb_graph test'
    album.location.should     == 'Tokyo, Japan'
    album.link.should         == 'http://www.facebook.com/album/12345'
    album.count.should        == 10
    album.created_time.should == Time.parse('2009-12-29T15:24:50+0000')
    album.updated_time.should == Time.parse('2010-01-02T15:37:41+0000')
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