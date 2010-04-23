require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::User, '.me' do
  it 'should return FbGraph::User instance with access_token' do
    FbGraph::User.me('access_token').should == FbGraph::User.new('me', :access_token => 'access_token')
  end
end

describe FbGraph::User, '#picture' do

  it 'should return image url' do
    FbGraph::User.new('matake').picture.should == File.join(FbGraph::ROOT_URL, 'matake/picture')
  end

  it 'should support size option' do
    [:square, :large].each do |size|
      FbGraph::User.new('matake').picture(size).should == File.join(FbGraph::ROOT_URL, "matake/picture?type=#{size}")
    end
  end

end

describe FbGraph::User, '#profile' do
  before(:all) do
    FakeWeb.register_uri(
      :get,
      'https://graph.facebook.com/arjun',
      :body => <<-JSON
        {
           "id": "7901103",
           "name": "Arjun Banker",
           "first_name": "Arjun",
           "last_name": "Banker",
           "link": "http://www.facebook.com/Arjun"
        }
      JSON
    )
    FakeWeb.register_uri(
      :get,
      'https://graph.facebook.com/arjun?access_token=access_token',
      :body => <<-JSON
        {
           "id": "7901103",
           "name": "Arjun Banker",
           "first_name": "Arjun",
           "last_name": "Banker",
           "link": "http://www.facebook.com/Arjun",
           "about": "squish squash\\npip pop\\nfizz bang",
           "birthday": "04/15/1984",
           "work": [
              {
                 "employer": {
                    "id": 20531316728,
                    "name": "Facebook"
                 },
                 "location": {
                    "id": 104022926303756,
                    "name": "Palo Alto, California"
                 },
                 "position": {
                    "id": 107879555911138,
                    "name": "Software Engineer"
                 },
                 "start_date": "2007-11"
              },
              {
                 "employer": {
                    "id": 113816405300191,
                    "name": "Zillow"
                 },
                 "position": {
                    "id": 105918922782444,
                    "name": "Business Intelligence Analyst"
                 },
                 "start_date": "2006-03",
                 "end_date": "2007-10"
              },
              {
                 "employer": {
                    "id": 20528438720,
                    "name": "Microsoft"
                 },
                 "position": {
                    "id": 110006949022640,
                    "name": "SDET"
                 },
                 "start_date": "2004-08",
                 "end_date": "2006-03"
              },
              {
                 "employer": {
                    "id": 7706457055,
                    "name": "Dell"
                 },
                 "position": {
                    "id": 110344568993267,
                    "name": "Programmer Analyst"
                 },
                 "start_date": "2003-06",
                 "end_date": "2004-07"
              }
           ],
           "education": [
              {
                 "school": {
                    "id": 107922345906866,
                    "name": "Texas Academy Of Math And Science"
                 },
                 "year": {
                    "id": 102241906483610,
                    "name": "2001"
                 }
              },
              {
                 "school": {
                    "id": 24147741537,
                    "name": "The University of Texas at Austin"
                 },
                 "year": {
                    "id": 108077232558120,
                    "name": "2003"
                 },
                 "concentration": [
                    {
                       "id": 116831821660155,
                       "name": "Computer Science"
                    }
                 ]
              }
           ],
           "interested_in": [
              "\\u5973\\u6027"
           ],
           "meeting_for": [
              "\\u53cb\\u60c5"
           ],
           "religion": "zorp",
           "timezone": -7,
           "updated_time": "2010-04-22T18:23:22+0000"
        }
      JSON
    )
  end

  describe 'when access_token is not given' do
    it 'should get only public profile' do
      profile = FbGraph::User.new('arjun').profile
      profile.name.should       == 'Arjun Banker'
      profile.first_name.should == 'Arjun'
      profile.last_name.should  == 'Banker'
      profile.identifier.should == '7901103'
      profile.link.should       == 'http://www.facebook.com/Arjun'
    end
  end

  describe 'when access_token is given' do
    it 'should get private profile too' do
      profile = FbGraph::User.new('arjun', :access_token => 'access_token').profile
      profile.name.should       == 'Arjun Banker'
      profile.first_name.should == 'Arjun'
      profile.last_name.should  == 'Banker'
      profile.identifier.should == '7901103'
      profile.link.should       == 'http://www.facebook.com/Arjun'
      profile.about.should      == "squish squash\npip pop\nfizz bang"
      profile.birthday.should   == '04/15/1984'
      profile.work.should       == []
      profile.education.should  == []
      profile.email.should      == nil
      profile.website.should    == nil
      # TODO
      puts profile.inspect
    end
  end
end