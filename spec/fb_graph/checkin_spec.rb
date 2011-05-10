require 'spec_helper'

describe FbGraph::Checkin, '.new' do
  it 'should accept FbGraph::Place as place' do
    checkin = FbGraph::Checkin.new(12345, :place => FbGraph::Place.new(123456))
    checkin.place.should == FbGraph::Place.new(123456)
  end

  it 'should accept String/Integer as place' do
    checkin1 = FbGraph::Checkin.new(12345, :place => 123456)
    checkin2 = FbGraph::Checkin.new(12345, :place => '123456')
    checkin1.place.should == FbGraph::Place.new(123456)
    checkin2.place.should == FbGraph::Place.new('123456')
  end
end

describe FbGraph::Checkin, '.search' do
  context 'when no access_token given' do
    it 'should raise FbGraph::Unauthorized' do
      mock_graph :get, 'search', 'checkins/search_public', :params => {
        :type => 'checkin'
      }, :status => [401, 'Unauthorized'] do
        lambda do
          FbGraph::Checkin.search
        end.should raise_exception(FbGraph::Unauthorized)
      end
    end
  end

  context 'when access_token is given' do
    it 'should return checkins as FbGraph::Checkin' do
      mock_graph :get, 'search', 'checkins/search_private', :access_token => 'access_token', :params => {
        :type => 'checkin'
      } do
        checkins = FbGraph::Checkin.search(:access_token => 'access_token')
        checkins.each do |checkin|
          checkin.should be_instance_of(FbGraph::Checkin)
        end
      end
    end
  end
end
