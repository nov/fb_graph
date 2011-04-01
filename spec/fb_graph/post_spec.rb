require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Post, '.new' do
  it 'should setup all supported attributes' do
    attributes = {
      :id => "579612276_10150089741782277",
      :message => "hello",
      :from => {
        :name => "Nov Matake",
        :id => "579612276"
      },
      :icon => "http://photos-d.ak.fbcdn.net/photos-ak-snc1/v27562/23/2231777543/app_2_2231777543_9553.gif",
      :type => "status",
      :attribution => "Twitter",
      :actions => [{
        :name => "Comment",
        :link => "http://www.facebook.com/579612276/posts/10150089741782277"
      }, {
        :name => "Like",
        :link => "http://www.facebook.com/579612276/posts/10150089741782277"
      }, {
        :name => "@nov on Twitter",
        :link => "http://twitter.com/nov?utm_source=fb&utm_medium=fb&utm_campaign=nov&utm_content=19294280413614080"
      }],
      :privacy => {
        :value => "EVERYONE",
        :description => "Everyone"
      },
      :targeting => {
        :country => 'ja'
      },
      :created_time => "2010-12-27T07:31:30+0000",
      :updated_time => "2010-12-27T07:31:30+0000"
    }
    post = FbGraph::Post.new(attributes.delete(:id), attributes)
    post.identifier.should == '579612276_10150089741782277'
    post.message.should == 'hello'
    post.from.should == FbGraph::User.new("579612276", :name => 'Nov Matake')
    post.icon.should == 'http://photos-d.ak.fbcdn.net/photos-ak-snc1/v27562/23/2231777543/app_2_2231777543_9553.gif'
    post.type.should == 'status'
    post.attribution.should == 'Twitter'
    post.actions.should == [
      FbGraph::Action.new(
        :name => "Comment",
        :link => "http://www.facebook.com/579612276/posts/10150089741782277"
      ),
      FbGraph::Action.new(
        :name => "Like",
        :link => "http://www.facebook.com/579612276/posts/10150089741782277"
      ),
      FbGraph::Action.new(
        :name => "@nov on Twitter",
        :link => "http://twitter.com/nov?utm_source=fb&utm_medium=fb&utm_campaign=nov&utm_content=19294280413614080"
      )
    ]
    post.privacy.should == FbGraph::Privacy.new(
      :value => "EVERYONE",
      :description => "Everyone"
    )
    post.targeting.should == FbGraph::Targeting.new(
      :country => 'ja'
    )
    post.created_time.should == Time.parse("2010-12-27T07:31:30+0000")
    post.updated_time.should == Time.parse("2010-12-27T07:31:30+0000")
  end

  it 'should support FbGraph::Privacy as privacy' do
    post = FbGraph::Post.new(12345, :privacy => FbGraph::Privacy.new(:value => 'EVERYONE'))
    post.privacy.should == FbGraph::Privacy.new(:value => 'EVERYONE')
  end

  it 'should support FbGraph::Targeting as targeting' do
    post = FbGraph::Post.new(12345, :targeting => FbGraph::Targeting.new(:country => 'ja'))
    post.targeting.should == FbGraph::Targeting.new(:country => 'ja')
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
      post.likes.should == [
        FbGraph::User.new("100000785546814", :name => "Anter Saied")
      ]
      post.likes.collection.total_count.should == 270
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
      post.created_time.should == Time.parse("2010-04-15T17:37:03+0000")
      post.updated_time.should == Time.parse("2010-04-22T18:19:13+0000")
      post.comments.size.should == 9
    end
  end

end

describe FbGraph::Post, '#to' do
  subject { post.to.first }

  context 'when include Event' do
    before do
      fake_json(:get, 'to_event', 'posts/to_event')
    end
    let(:post) { FbGraph::Post.fetch('to_event') }
    it { should be_instance_of FbGraph::Event }
  end

  context 'when include Application' do
    context 'when fetched as Application#feed' do
      before do
        fake_json(:get, 'app/feed', 'applications/feed/public')
      end
      let(:post) { FbGraph::Application.new('app').feed.first }
      it { should be_instance_of FbGraph::Application }
    end

    context 'otherwize' do # no way to detect this case..
      before do
        fake_json(:get, 'to_application', 'posts/to_application')
      end
      let(:post) { FbGraph::Post.fetch('to_application') }
      it { should be_instance_of FbGraph::User }
    end
  end

  context 'when include Group' do
    before do
      fake_json(:get, 'to_group?access_token=access_token', 'posts/to_group')
    end
    let(:post) { FbGraph::Post.fetch('to_group', :access_token => 'access_token') }
    it { should be_instance_of FbGraph::Group }
  end

end