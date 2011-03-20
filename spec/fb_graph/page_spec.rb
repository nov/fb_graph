require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Page, '.new' do
  it 'should setup all supported attributes' do
    attributes = {
      :id => '19292868552',
      :name => 'Facebook Platform',
      :founded => 'May 2007',
      :category => 'Technology',
      :username => 'platform',
      :mission => 'To make the web more open and social.',
      :products => "Facebook Application Programming Interface (API)\nFacebook Query Language (FQL)\nFacebook Markup Language (FBML)\nFacebook JavaScript (FBJS)\nFacebook Connect\n",
      :likes => 578246,
      :company_overview => 'Facebook Platform enables anyone to build social applications on Facebook and the web.',
      :link => 'http://www.facebook.com/platform',
      :picture => 'http://profile.ak.fbcdn.net/profile-ak-snc1/object3/1566/8/s19292868552_1660.jpg',
      :website => 'http://developers.facebook.com'
    }
    page = FbGraph::Page.new(attributes.delete(:id), attributes)
    page.identifier.should == '19292868552'
    page.name.should       == 'Facebook Platform'
    page.founded.should    == Date.new(2007, 5)
    page.category.should   == 'Technology'
    page.username.should   == 'platform'
    page.mission.should    == 'To make the web more open and social.'
    page.products.should   == "Facebook Application Programming Interface (API)\nFacebook Query Language (FQL)\nFacebook Markup Language (FBML)\nFacebook JavaScript (FBJS)\nFacebook Connect\n"
    page.like_count.should == 578246
    page.company_overview.should == 'Facebook Platform enables anyone to build social applications on Facebook and the web.'
    page.link.should     == 'http://www.facebook.com/platform'
    page.picture.should  == 'https://graph.facebook.com/19292868552/picture' # use connection
    page.website.should  == 'http://developers.facebook.com'
  end

  it 'should allow invalid date as founded' do
    page = FbGraph::Page.new(12345, :founded => "2004")
    page.founded.should == '2004'
  end

  it 'should allow invalid date as release_date' do
    page1 = FbGraph::Page.new(12345, :release_date => "2010-04-23")
    page1.release_date.should == Date.new(2010, 4, 23)
    page2 = FbGraph::Page.new(12345, :release_date => "someday")
    page2.release_date.should == 'someday'
  end
end

describe FbGraph::Page, '.fetch' do
  before do
    fake_json(:get, 'platform', 'pages/platform_public')
    fake_json(:get, 'platform?access_token=access_token', 'pages/platform_private')
  end

  it 'should get page attributes' do
    page = FbGraph::Page.fetch('platform')
    page.identifier.should == '19292868552'
    page.name.should       == 'Facebook Platform'
    page.category.should   == 'Technology'
  end
end