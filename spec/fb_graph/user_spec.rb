require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::User, '.me' do
  it 'should return FbGraph::User instance with token' do
    FbGraph::User.me('token').should == FbGraph::User.new('me', :token => 'token')
  end
end

describe FbGraph::User, '.fetch' do
  before(:all) do
    fake_json(:get, 'arjun', 'users/arjun_public')
    fake_json(:get, 'arjun?token=token', 'users/arjun_private')
  end

  it 'should get only public profile when no token given' do
    user = FbGraph::User.fetch('arjun')
    user.name.should       == 'Arjun Banker'
    user.first_name.should == 'Arjun'
    user.last_name.should  == 'Banker'
    user.identifier.should == '7901103'
    user.link.should       == 'http://www.facebook.com/Arjun'
  end

  it 'should get public + private profile when token given' do
    user = FbGraph::User.fetch('arjun', :token => 'token')
    # public
    user.name.should       == 'Arjun Banker'
    user.first_name.should == 'Arjun'
    user.last_name.should  == 'Banker'
    user.identifier.should == '7901103'
    user.link.should       == 'http://www.facebook.com/Arjun'

    # private
    user.about.should      == "squish squash\npip pop\nfizz bang"
    user.birthday.should   == '04/15/1984'
    user.work.should       == [{'position'=>{'name'=>'Software Engineer', 'id'=>107879555911138}, 'start_date'=>'2007-11', 'location'=>{'name'=>'Palo Alto, California', 'id'=>104022926303756}, 'employer'=>{'name'=>'Facebook', 'id'=>20531316728}}, {'position'=>{'name'=>'Business Intelligence Analyst', 'id'=>105918922782444}, 'start_date'=>'2006-03', 'employer'=>{'name'=>'Zillow', 'id'=>113816405300191}, 'end_date'=>'2007-10'}, {'position'=>{'name'=>'SDET', 'id'=>110006949022640}, 'start_date'=>'2004-08', 'employer'=>{'name'=>'Microsoft', 'id'=>20528438720}, 'end_date'=>'2006-03'}, {'position'=>{'name'=>'Programmer Analyst', 'id'=>110344568993267}, 'start_date'=>'2003-06', 'employer'=>{'name'=>'Dell', 'id'=>7706457055}, 'end_date'=>'2004-07'}]
    user.education.should  == [{'school'=>{'name'=>'Texas Academy Of Math And Science', 'id'=>107922345906866}, 'year'=>{'name'=>'2001', 'id'=>102241906483610}}, {'school'=>{'name'=>'The University of Texas at Austin', 'id'=>24147741537}, 'concentration'=>[{'name'=>'Computer Science', 'id'=>116831821660155}], 'year'=>{'name'=>'2003', 'id'=>108077232558120}}]
    user.email.should      == nil
    user.website.should    == nil
  end
end