require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::User, '.me' do
  it 'should return FbGraph::User instance with access_token' do
    FbGraph::User.me('access_token').should == FbGraph::User.new('me', :access_token => 'access_token')
  end
end

describe FbGraph::User, '.fetch' do
  before(:all) do
    fake_json(:get, 'arjun', 'users/arjun_public')
    fake_json(:get, 'arjun?access_token=access_token', 'users/arjun_private')
  end

  context 'when no access_token given' do
    it 'should get only public profile' do
      user = FbGraph::User.fetch('arjun')
      user.name.should       == 'Arjun Banker'
      user.first_name.should == 'Arjun'
      user.last_name.should  == 'Banker'
      user.identifier.should == '7901103'
      user.link.should       == 'http://www.facebook.com/Arjun'
    end
  end

  context 'when access_token given' do
    it 'should get public + private profile' do
      user = FbGraph::User.fetch('arjun', :access_token => 'access_token')

      # public
      user.name.should       == 'Arjun Banker'
      user.first_name.should == 'Arjun'
      user.last_name.should  == 'Banker'
      user.identifier.should == '7901103'
      user.link.should       == 'http://www.facebook.com/Arjun'

      # private
      user.about.should    == "squish squash\npip pop\nfizz bang"
      user.birthday.should == Date.parse('04/15/1984')
      user.work.should     == [
        FbGraph::Work.new({
          :employer   => {:name => 'Facebook', :id => 20531316728},
          :position   => {:name => 'Software Engineer', :id => 107879555911138},
          :location   => {:name => 'Palo Alto, California', :id => 104022926303756},
          :start_date => '2007-11'
        }),
        FbGraph::Work.new({
          :employer   => {:name => 'Zillow', :id => 113816405300191},
          :position   => {:name => 'Business Intelligence Analyst', :id => 105918922782444},
          :start_date => '2006-03',
          :end_date   => '2007-10'
        }),
        FbGraph::Work.new({
          :employer   => {:name => 'Microsoft', :id => 20528438720},
          :position   => {:name => 'SDET', :id => 110006949022640},
          :start_date => '2004-08',
          :end_date   => '2006-03'
        }),
        FbGraph::Work.new({
          :employer   => {:name => 'Dell', :id => 7706457055},
          :position   => {:name => 'Programmer Analyst', :id => 110344568993267},
          :start_date => '2003-06',
          :end_date   => '2004-07'
        })
      ]
      user.education.should == [
        FbGraph::Education.new({
          :school => {:name => 'Texas Academy Of Math And Science', :id => 107922345906866},
          :year   => {:name => '2001', :id => 102241906483610}
        }),
        FbGraph::Education.new({
          :school => {:name => 'The University of Texas at Austin', :id => 24147741537},
          :year   => {:name => '2003', :id => 108077232558120},
          :concentration => [
            {:name => 'Computer Science', :id => 116831821660155}
          ]
        })
      ]
      user.email.should   == nil
      user.website.should == []
    end
  end
end