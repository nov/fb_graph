require 'spec_helper'

describe FbGraph::Connections::PromotablePosts do
  describe '#promotable_posts' do
    it 'should return promotable posts the user created as FbGraph::Post' do
      mock_graph :get, 'FbGraph/promotable_posts', 'pages/promotable_posts/sample', :access_token => 'access_token' do
        posts = FbGraph::Page.new('FbGraph', :access_token => 'access_token').promotable_posts
        posts.class.should == FbGraph::Connection
        posts.count.should == 4
        posts.each.with_index do |post, index|
          post.should be_instance_of FbGraph::PromotablePost
          case index
          when 0
            post.is_published.should be_false
            post.scheduled_publish_time.should == Time.at(1352473200)
          else
            post.is_published.should be_true
            post.scheduled_publish_time.should be_nil
          end
        end
      end
    end
  end
end