require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Event, '.new' do

  it 'should setup all supported attributes' do
    attributes = {
      :id => '12345',
      :owner => {
        :id => '23456',
        :name => 'nov matake'
      },
      :name => 'event 1',
      :description => 'an event for fb_graph test',
      :start_time => '2010-03-14T21:00:00+0000',
      :end_time => 1268613000, # 2010-03-15T00:30:00+0000
      :location => 'Smart.fm office',
      :venue => {
        :street => 'Sakuragaoka',
        :city => 'Shibuya',
        :state => 'Tokyo',
        :zip => '150-0031',
        :country => 'Japan',
        :latitude => '35.685',
        :longitude => '139.751'
      },
      :privacy => 'OPEN',
      :updated_time => Time.at(1262446661) # 2010-01-02T15:37:41+0000
    }
    event = FbGraph::Event.new(attributes.delete(:id), attributes)
    event.identifier.should   == '12345'
    event.owner.should        == FbGraph::User.new('23456', :name => 'nov matake')
    event.name.should         == 'event 1'
    event.description.should  == 'an event for fb_graph test'
    event.start_time.should   == Time.parse('2010-03-14T21:00:00+0000')
    event.end_time.should     == Time.parse('2010-03-15T00:30:00+0000')
    event.location.should     == 'Smart.fm office'
    event.venue.should        == FbGraph::Venue.new(
      :street => 'Sakuragaoka',
      :city => 'Shibuya',
      :state => 'Tokyo',
      :zip => '150-0031',
      :country => 'Japan',
      :latitude => '35.685',
      :longitude => '139.751'
    )
    event.privacy.should      == 'OPEN'
    event.updated_time.should == Time.parse('2010-01-02T15:37:41+0000')
  end

end
