require 'spec_helper'

describe FbGraph::User, '.new' do
  it 'should setup all supported attributes' do
    attributes = {
      :id => '12345',
      :address => {
        :city => "Kawasaki",
        :state => "Kanagawa",
        :country => "Japan"
      },
      :mobile_phone => '810000000000',
      :installed => true
    }
    user = FbGraph::User.new(attributes.delete(:id), attributes)
    user.address.should == FbGraph::Venue.new(attributes[:address])
    user.mobile_phone.should == '810000000000'
    user.installed.should be_true
  end

  it 'should support year-hidden birthday' do
    user = FbGraph::User.new(12345, :birthday => '12/13')
    user.birthday.year.should  == 0
    user.birthday.month.should == 12
    user.birthday.day.should   == 13
  end
end

describe FbGraph::User, '.me' do
  it 'should return FbGraph::User instance with access_token' do
    FbGraph::User.me('access_token').should == FbGraph::User.new('me', :access_token => 'access_token')
  end
end

describe FbGraph::User, '.fetch' do
  context 'with me context' do

    context 'when no access_token given' do
      it 'should raise FbGraph::Unauthorized' do
        mock_graph :get, 'me', 'users/me_public', :status => [401, 'Unauthorized'] do
          lambda do
            FbGraph::User.fetch('me')
          end.should raise_exception(FbGraph::Unauthorized)
        end
      end
    end

    context 'when access_token given' do
      it 'should get current user profile' do
        mock_graph :get, 'me', 'users/me_private', :access_token => 'access_token' do
          user = FbGraph::User.me('access_token').fetch
          user.interested_in.should       == ['female']
          user.relationship_status.should == 'Married'
          user.website.should             == 'http://matake.jp'
          user.religion.should            be_nil
          user.political.should           be_nil
          user.timezone.should            == 9
          user.verified.should            be_true
        end
      end
    end

  end

  context 'when no access_token given' do
    it 'should get only public profile' do
      mock_graph :get, 'arjun', 'users/arjun_public' do
        user = FbGraph::User.fetch('arjun')
        user.name.should       == 'Arjun Banker'
        user.first_name.should == 'Arjun'
        user.last_name.should  == 'Banker'
        user.identifier.should == '7901103'
        user.link.should       == 'http://www.facebook.com/Arjun'
        user.location.should   == FbGraph::Page.new(114952118516947, :name => 'San Francisco, California')
        user.gender.should     == 'male'
      end
    end
  end

  context 'when access_token given' do
    it 'should get public + private profile' do
      mock_graph :get, 'arjun', 'users/arjun_private', :access_token => 'access_token' do
        user = FbGraph::User.fetch('arjun', :access_token => 'access_token')

        # public
        user.name.should       == 'Arjun Banker'
        user.first_name.should == 'Arjun'
        user.last_name.should  == 'Banker'
        user.identifier.should == '7901103'
        user.link.should       == 'http://www.facebook.com/Arjun'
        user.location.should   == FbGraph::Page.new(114952118516947, :name => 'San Francisco, California')
        user.gender.should     == 'male'

        # private
        user.about.should    == 'daydrea'
        user.birthday.should == Date.strptime("04/15/1984", "%m/%d/%Y")
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
        user.email.should               == nil
        user.website.should             == nil
        user.hometown.should            == FbGraph::Page.new(109533479072558, :name => 'Minnetonka, Minnesota')
        user.interested_in.should       == ['female']
        user.relationship_status.should == 'In a Relationship'
        user.religion.should            == 'zorp'
        user.political.should           == 'Liberal'
        user.verified.should            be_nil
        # What's this?
        # user.significant_other
        user.timezone.should            be_nil
        user.updated_time.should        == Time.parse('2010-05-29T04:29:23+0000')
      end
    end
  end
end