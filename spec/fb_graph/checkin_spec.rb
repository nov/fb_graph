require File.join(File.dirname(__FILE__), '../spec_helper')

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
  before do
    fake_json(:get, 'search?type=checkin', 'checkins/search_public')
    fake_json(:get, 'search?type=checkin&access_token=access_token', 'checkins/search_private')
  end

  context 'when no access_token given' do
    it 'should raise FbGraph::Unauthorized' do
      lambda do
        FbGraph::Checkin.search
      end.should raise_exception(FbGraph::Unauthorized)
    end
  end

  context 'when access_token is given' do
    it 'should return checkins as FbGraph::Checkin' do
      checkins = FbGraph::Checkin.search(:access_token => 'access_token')
      checkins.each do |checkin|
        checkin.should be_instance_of(FbGraph::Checkin)
      end
    end
  end
end
