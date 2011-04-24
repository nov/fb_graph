require 'spec_helper'

describe FbGraph::Venue, '.new' do

  it 'should setup all supported attributes' do
    attributes = {
      :street => "409 Colorado St.",
      :city => "Austin",
      :state => "Texas",
      :country => "United States",
      :latitude => 30.2669,
      :longitude => -97.7428
    }
    venue = FbGraph::Venue.new(attributes)
    venue.street.should == "409 Colorado St."
    venue.city.should == "Austin"
    venue.state.should == "Texas"
    venue.country.should == "United States"
    venue.latitude.should == 30.2669
    venue.longitude.should == -97.7428
  end

end