require 'spec_helper'

describe FbGraph::Message, '.new' do
  it 'should setup all supported attributes' do
    attributes = {
      :id => "12345",
      :created_time => "2011-02-04T15:11:05+0000",
      :tags => {
        :data => [{
          :name => "inbox"
        }, {
          :name => "source:web"
        }]
      },
      :from => {
        :name => "Nov Matake",
        :email => "abc@facebook.com",
        :id => "1575327134"
      },
      :to => {
        :data => [{
          :name => "Nov Matake",
          :email => "xyz@facebook.com",
          :id => "579612276"
        }, {
          :name => "Nov Matake",
          :email => "abc@facebook.com",
          :id => "1575327134"
        }]
      },
      :message => "test test"
    }
    message = FbGraph::Message.new(attributes.delete(:id), attributes)
    message.identifier.should == '12345'
    message.message.should == 'test test'
    message.created_time.should == Time.parse('2011-02-04T15:11:05+0000')
    message.tags.should == [
      FbGraph::Tag.new(:name => 'inbox'),
      FbGraph::Tag.new(:name => 'source:web')
    ]
    message.from.should == FbGraph::User.new('1575327134', :name => 'Nov Matake', :email => 'abc@facebook.com')
    message.to.should == [
      FbGraph::User.new('579612276', :name => 'Nov Matake', :email => 'xyz@facebook.com'),
      FbGraph::User.new('1575327134', :name => 'Nov Matake', :email => 'abc@facebook.com')
    ]
  end
end