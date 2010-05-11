require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Photo, '.new' do

  it 'should setup all supported attributes' do
    attributes = {
      :id => '12345',
      :from => {
        :id => '23456',
        :name => 'nov matake'
      },
      :tags => {
        :data => [{
          :id => '12345',
          :name => 'nov matake',
          :x => 32.5,
          :y => 27.7778,
          :created_time => '2010-01-10T15:37:40+0000'
        }]
      },
      :name => 'photo 1',
      :picture => 'http://www.facebook.com/matake/picture/album_size',
      :source => 'http://www.facebook.com/matake/picture/original_size',
      :height => 100,
      :width => 200,
      :link => 'http://www.facebook.com/photo/12345',
      :created_time => '2010-01-02T15:37:40+0000',
      :updated_time => '2010-01-02T15:37:41+0000'
    }
    photo = FbGraph::Photo.new(attributes.delete(:id), attributes)
    photo.identifier.should   == '12345'
    photo.from.should         == FbGraph::User.new('23456', :name => 'nov matake')
    photo.tags.should         == [FbGraph::Tag.new(
      '12345',
      :name => 'nov matake',
      :x => 32.5,
      :y => 27.7778,
      :created_time => '2010-01-10T15:37:40+0000'
    )]
    photo.picture.should      == 'http://www.facebook.com/matake/picture/album_size'
    photo.source.should       == 'http://www.facebook.com/matake/picture/original_size'
    photo.height.should       == 100
    photo.width.should        == 200
    photo.link.should         == 'http://www.facebook.com/photo/12345'
    photo.created_time.should == Time.parse('2010-01-02T15:37:40+0000')
    photo.updated_time.should == Time.parse('2010-01-02T15:37:41+0000')
  end

  it 'should support page as from' do
    page_photo = FbGraph::Photo.new('12345', :from => {
      :id => '23456',
      :name => 'Smart.fm',
      :category => 'Web Site'
    })
    page_photo.from.should == FbGraph::Page.new('23456', :name => 'Smart.fm', :category => 'Web Site')
  end

end