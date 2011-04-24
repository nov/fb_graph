require 'spec_helper'

describe FbGraph::Thread, '.new' do
  it 'should setup all supported attributes' do
    attributes = {
      :id => "12345",
      :snippet => 'test message',
      :message_count => 2,
      :unread_count => 1,
      :updated_time => "2011-02-04T15:11:05+0000",
      :tags => {
        :data => [{
          :name => "inbox"
        }, {
          :name => "source:web"
        }]
      },
      :participants => {
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
      :senders => {
        :data => [{
          :name => "Nov Matake",
          :email => "abc@facebook.com",
          :id => "1575327134"
        }]
      },
      :messages => {
        :data => [{
          :id => "m_25aaa73097e54594addb418c7bfbd05c",
          :subject => "test",
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
          :message => "test"
        }],
        :paging => {
          :previous => "https://graph.facebook.com/?access_token=access_token",
          :next => "https://graph.facebook.com/?access_token=access_token"
        }
      }
    }
    thread = FbGraph::Thread.new(attributes.delete(:id), attributes)
    thread.identifier.should == '12345'
    thread.snippet.should == 'test message'
    thread.message_count.should == 2
    thread.unread_count.should == 1
    thread.updated_time.should == Time.parse('2011-02-04T15:11:05+0000')
    thread.tags.should == [
      FbGraph::Tag.new(:name => 'inbox'),
      FbGraph::Tag.new(:name => 'source:web')
    ]
    thread.senders.should == [
      FbGraph::User.new('1575327134', :name => 'Nov Matake', :email => 'abc@facebook.com')
    ]
  end
end