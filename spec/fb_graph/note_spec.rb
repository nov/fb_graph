require 'spec_helper'

describe FbGraph::Note, '.new' do

  it 'should setup all supported attributes' do
    attributes = {
      :id => '12345',
      :from => {
        :id => '23456',
        :name => 'nov matake'
      },
      :subject => 'TODO',
      :message => 'later or never',
      :created_time => '2010-01-02T15:37:40+0000',
      :updated_time => '2010-01-02T15:37:41+0000',
      :icon => 'http://static.ak.fbcdn.net/rsrc.php/z7NSY/hash/ajh5dbgz.gif'
    }
    note = FbGraph::Note.new(attributes.delete(:id), attributes)
    note.identifier.should   == '12345'
    note.from.should         == FbGraph::User.new('23456', :name => 'nov matake')
    note.subject.should      == 'TODO'
    note.message.should      == 'later or never'
    note.created_time.should == Time.parse('2010-01-02T15:37:40+0000')
    note.updated_time.should == Time.parse('2010-01-02T15:37:41+0000')
    note.icon.should         == 'http://static.ak.fbcdn.net/rsrc.php/z7NSY/hash/ajh5dbgz.gif'
  end

  it 'should support page as from' do
    page_note = FbGraph::Note.new('12345', :from => {
      :id => '23456',
      :name => 'Smart.fm',
      :category => 'Web Site'
    })
    page_note.from.should == FbGraph::Page.new('23456', :name => 'Smart.fm', :category => 'Web Site')
  end

end