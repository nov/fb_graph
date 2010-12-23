require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Post, '.new' do
  it 'should setup all supported attributes' do
    # TODO
  end

  it 'should support page as from' do
    page_post = FbGraph::Post.new('12345', :from => {
      :id => '23456',
      :name => 'Smart.fm',
      :category => 'Web Site'
    }, :message => 'Hello')
    page_post.from.should == FbGraph::Page.new('23456', :name => 'Smart.fm', :category => 'Web Site')
  end

  it 'should support page as to' do
    page_post = FbGraph::Post.new('12345', :to => {:data => [
      :id => '23456',
      :name => 'Smart.fm',
      :category => 'Web Site'
    ]}, :message => 'Hello')
    page_post.to.first.should == FbGraph::Page.new('23456', :name => 'Smart.fm', :category => 'Web Site')
  end
end

describe FbGraph::Post, '#fetch' do

  context 'when no access_token given' do
    before do
      fake_json(:get, 'platform', 'posts/platform_public')
    end

    it 'should get all attributes except some comments' do
      post = FbGraph::Post.fetch('platform')
      post.identifier.should == '19292868552_118464504835613'
      post.from.should == FbGraph::Page.new(
        "19292868552",
        :name => "Facebook Platform",
        :category => "Technology"
      )
      post.message.should == "We're getting ready for f8! Check out the latest on the f8 Page, including a video from the first event, when Platform launched :: http://bit.ly/ahHl7j"
      post.like_count.should == 61
      post.created_time.should == Time.parse("2010-04-15T17:37:03+0000")
      post.updated_time.should == Time.parse("2010-04-22T18:19:13+0000")
      post.comments.size.should == 4
    end
  end

  context 'when access_token given' do
    before do
      fake_json(:get, 'platform?access_token=access_token', 'posts/platform_private')
    end

    it 'shold get all attributes and comments' do
      post = FbGraph::Post.fetch('platform', :access_token => 'access_token')
      post.identifier.should == '19292868552_118464504835613'
      post.from.should == FbGraph::Page.new(
        "19292868552",
        :name => "Facebook Platform",
        :category => "Technology"
      )
      post.message.should == "We're getting ready for f8! Check out the latest on the f8 Page, including a video from the first event, when Platform launched :: http://bit.ly/ahHl7j"
      post.like_count.should == 61
      post.created_time.should == Time.parse("2010-04-15T17:37:03+0000")
      post.updated_time.should == Time.parse("2010-04-22T18:19:13+0000")
      post.comments.size.should == 9
    end
  end

end