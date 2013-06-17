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

describe FbGraph::Comment, '#fetch' do

  context 'when access_token given' do
    it 'gets the comment message, attributes, and user object' do
      mock_graph :get, 'comment_id', 'comments/comment', :access_token => 'access_token' do
        comment = FbGraph::Comment.fetch("comment_id", :access_token => 'access_token')
        comment.identifier.should == '10151705618661509_29545180'
        comment.can_comment == nil
      end
    end

    it "gets the list of replies for the comment" do
      mock_graph :get, 'comment_id/comments', 'comments/comments/with_cursor_paging_params', :access_token => 'access_token' do
        replies = FbGraph::Comment.new("comment_id", :access_token => 'access_token').comments
        replies.should be_instance_of FbGraph::Connection
        replies.should be_a FbGraph::Collection
        replies.collection.next.should include :limit, :after
        replies.collection.previous.should include :limit, :before
        replies.collection.cursors.should include :before, :after
      end
    end

    context 'when can_comment is passed into the fields parameter' do
      it 'gets the can_comment attribute' do
        mock_graph :get, 'comment_id', 'comments/with_can_comment', :access_token => 'access_token', :params => { :fields => 'can_comment' } do
          comment = FbGraph::Comment.fetch("comment_id", :access_token => 'access_token', :fields => 'can_comment')
          comment.identifier.should == '10151705618661509_29545180'
          comment.can_comment.should == true
        end
      end
    end

  end

end