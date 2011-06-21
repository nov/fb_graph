require 'spec_helper'

describe FbGraph::Link, '.new' do

  it 'should setup all supported attributes' do
    attributes = {
      :id => '12345',
      :from => {
        :id => '23456',
        :name => 'nov matake'
      },
      :link => 'http://www.facebook.com/link/12345',
      :name => 'name',
      :description => 'description',
      :icon => 'http://static.ak.fbcdn.net/rsrc.php/zB010/hash/9yvl71tw.gif',
      :picture => 'http://i.ytimg.com/vi/JA068qeB0oM/2.jpg',
      :message => 'check this out!',
      :created_time => '2010-01-02T15:37:41+0000'
    }
    link = FbGraph::Link.new(attributes.delete(:id), attributes)
    link.identifier.should   == '12345'
    link.from.should         == FbGraph::User.new('23456', :name => 'nov matake')
    link.link.should         == 'http://www.facebook.com/link/12345'
    link.name.should         == 'name'
    link.description.should  == 'description'
    link.icon.should         == 'http://static.ak.fbcdn.net/rsrc.php/zB010/hash/9yvl71tw.gif'
    link.picture.should      == 'http://i.ytimg.com/vi/JA068qeB0oM/2.jpg'
    link.message.should      == 'check this out!'
    link.created_time.should == Time.parse('2010-01-02T15:37:41+0000')
  end

  it 'should support page as from' do
    page_link = FbGraph::Link.new('12345', :from => {
      :id => '23456',
      :name => 'Smart.fm',
      :category => 'Web Site'
    })
    page_link.from.should == FbGraph::Page.new('23456', :name => 'Smart.fm', :category => 'Web Site')
  end

end