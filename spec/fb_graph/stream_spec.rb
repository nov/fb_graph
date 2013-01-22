require 'spec_helper'

describe FbGraph::Stream, '.new' do
  let(:attributes) do
    {
      :post_id  => '229631577118807_241736129241685',
      :likes    => {
          :href => "https://www.facebook.com/browse/likes/?id=229648553783776", 
          :count => 1, 
          :sample => [], 
          :friends => [], 
          :user_likes => true, 
          :can_like => true
        },
      :share_count => 1,
      :comments => {
        :can_remove => true, 
        :can_post =>true, 
        :count => 1, 
        :comment_list => [
          {
            :fromid => 229631577118807, 
            :time =>1328739424, 
            :text => "comment post", 
            :text_tags => [], 
            :id => "229631577118807_229648553783776_1469128", 
            :likes => 1, 
            :user_likes => true, 
            :post_fbid => 242669565815008
          }
        ]
      }, 
      :viewer_id => 692071063, 
      :app_id => nil, 
      :updated_time => 1328739428, 
      :created_time => 1327100868, 
      :filter_key => "", 
      :attribution => nil, 
      :actor_id => 229631577118807, 
      :target_id => nil, 
      :message => "Welcome to Kinetic Social", 
      :app_data => [], 
      :action_links => nil, 
      :attachment => {
        :description => ""
      }, 
      :impressions => nil, 
      :place => nil, 
      :description => nil, 
      :type  =>  46
    }
  end
  subject do
    FbGraph::Stream.new(attributes[:post_id], attributes)
  end

  its(:identifier)          { should == attributes[:post_id]  }
  its(:likes)               { should == attributes[:likes]    }
  its(:share_count)         { should == attributes[:share_count] }
  its(:comments)            { should == attributes[:comments] }
  its(:viewer_id)           { should == attributes[:viewer_id] }
  its(:updated_time)        { should == attributes[:updated_time] }
  its(:created_time)        { should == attributes[:created_time] }
  its(:actor_id)            { should == attributes[:actor_id] }
  its(:message)             { should == attributes[:message] }

end

describe FbGraph::Stream, '.fetch' do
  context 'when access_token given' do
    it 'should get all attributes and comments of a post' do
      mock_graph :get, 'platform', 'posts/platform_private', :access_token => 'access_token' do
        post = FbGraph::Stream.fetch('platform', :access_token => 'access_token')
        post.should_not be_instance_of(FbGraph::Stream)
        post.should be_instance_of(FbGraph::Post)
        post.identifier.should == '19292868552_118464504835613'
        post.from.should == FbGraph::Page.new(
          "19292868552",
          :name => "Facebook Platform",
          :category => "Technology"
        )
        post.message.should == "We're getting ready for f8! Check out the latest on the f8 Page, including a video from the first event, when Platform launched :: http://bit.ly/ahHl7j"
        post.created_time.should == Time.parse("2010-04-15T17:37:03+0000")
        post.updated_time.should == Time.parse("2010-04-22T18:19:13+0000")
        post.comments.size.should == 9
      end
    end
  end
end
