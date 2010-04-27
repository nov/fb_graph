require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Video, '#new' do

  it 'should setup all supported attributes' do
    attributes = {
      :id => '12345',
      :from => {
        :id => '23456',
        :name => 'nov matake'
      },
      :message => 'check this out!',
      :description => 'Smart.fm learning engine details',
      :length => 3600,
      :created_time => '2010-01-02T15:37:40+0000',
      :updated_time => '2010-01-02T15:37:41+0000'
    }
    video = FbGraph::Video.new(attributes.delete(:id), attributes)
    video.identifier.should   == '12345'
    video.from.should         == FbGraph::User.new('23456', :name => 'nov matake')
    video.message.should      == 'check this out!'
    video.description.should  == 'Smart.fm learning engine details'
    video.length.should       == 3600
    video.created_time.should == '2010-01-02T15:37:40+0000'
    video.updated_time.should == '2010-01-02T15:37:41+0000'
  end

  it 'should support page as from' do
    page_video = FbGraph::Video.new('12345', :from => {
      :id => '23456',
      :name => 'Smart.fm',
      :category => 'Web Site'
    })
    page_video.from.should == FbGraph::Page.new('23456', :name => 'Smart.fm', :category => 'Web Site')
  end

end