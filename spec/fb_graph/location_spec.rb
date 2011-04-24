require 'spec_helper'

describe FbGraph::Location, '.new' do

  it 'should setup all supported attributes' do
    attributes = {
      :latitude => 30.2669,
      :longitude => -97.7428
    }
    location = FbGraph::Location.new(attributes)
    location.latitude.should == 30.2669
    location.longitude.should == -97.7428
  end

end

describe FbGraph::Location, '.to_hash' do

  it 'should setup all supported attributes' do
    attributes = {
      :latitude => 30.2669,
      :longitude => -97.7428
    }
    location = FbGraph::Location.new(attributes)
    location.to_hash == attributes
  end

end