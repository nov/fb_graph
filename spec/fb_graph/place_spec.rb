require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Place, '.to_json' do
  it 'should return identifier' do
    place = FbGraph::Place.new(12345)
    place.to_json.should == 12345
  end
end