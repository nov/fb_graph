require 'spec_helper'

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
      :images => [{
        :height => 483,
        :width  => 720,
        :source => "https://fbcdn-sphotos-a.akamaihd.net/hphotos-ak-ash1/168119_10150146071831729_20531316728_7844072_5116892_n.jpg"
      },
      {
        :height => 120,
        :width  => 180,
        :source => "https://fbcdn-photos-a.akamaihd.net/hphotos-ak-ash1/168119_10150146071831729_20531316728_7844072_5116892_a.jpg"
      },
      {
        :height => 87,
        :width  => 130,
        :source => "https://fbcdn-photos-a.akamaihd.net/hphotos-ak-ash1/168119_10150146071831729_20531316728_7844072_5116892_s.jpg"
      },
      {
        :height => 50,
        :width  => 75,
        :source => "https://fbcdn-photos-a.akamaihd.net/hphotos-ak-ash1/168119_10150146071831729_20531316728_7844072_5116892_t.jpg"
      }],
      :place => {
        :id => "113537565323646",
        :name => "Altavilla Vicentina",
        :location => {
          :street => "",
          :zip => "",
          :latitude => 45.5167,
          :longitude => 11.4667
        }
      },
      :name => 'photo 1',
      :picture => 'http://www.facebook.com/matake/picture/album_size',
      :icon => 'http://static.ak.fbcdn.net/rsrc.php/z2E5Y/hash/8as8iqdm.gif',
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
      :id => '12345',
      :name => 'nov matake',
      :x => 32.5,
      :y => 27.7778,
      :created_time => '2010-01-10T15:37:40+0000'
    )]
    photo.images.first.should == FbGraph::Image.new(
      :height => 483,
      :width  => 720,
      :source => "https://fbcdn-sphotos-a.akamaihd.net/hphotos-ak-ash1/168119_10150146071831729_20531316728_7844072_5116892_n.jpg"
    )
    photo.place.should == FbGraph::Page.new("113537565323646", :name => "Altavilla Vicentina", :location => { :street => "", :zip => "", :latitude => 45.5167, :longitude => 11.4667 })
    photo.place.location.longitude.should == 11.4667
    photo.picture.should      == 'https://graph.facebook.com/12345/picture'
    photo.icon.should         == 'http://static.ak.fbcdn.net/rsrc.php/z2E5Y/hash/8as8iqdm.gif'
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
