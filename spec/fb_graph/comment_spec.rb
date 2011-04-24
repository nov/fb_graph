require 'spec_helper'

describe FbGraph::Comment, '.new' do

  it 'should setup all supported attributes' do
    attributes = {
      :id => '12345',
      :from => {
        :id => '23456',
        :name => 'nov matake'
      },
      :message => 'hello',
      :created_time => '2010-01-02T15:37:40+0000'
    }
    comment = FbGraph::Comment.new(attributes.delete(:id), attributes)
    comment.identifier.should   == '12345'
    comment.from.should         == FbGraph::User.new('23456', :name => 'nov matake')
    comment.message.should      == 'hello'
    comment.created_time.should == Time.parse('2010-01-02T15:37:40+0000')
  end

  it 'should support page as from' do
    page_comment = FbGraph::Comment.new('12345', :from => {
      :id => '23456',
      :name => 'Smart.fm',
      :category => 'Web Site'
    })
    page_comment.from.should == FbGraph::Page.new('23456', :name => 'Smart.fm', :category => 'Web Site')
  end

end