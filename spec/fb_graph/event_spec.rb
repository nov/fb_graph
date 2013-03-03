require 'spec_helper'

describe FbGraph::Event do
  let :attributes do
    {
      :id => '12345',
      :owner => {
        :id => '23456',
        :name => 'nov matake'
      },
      :name => 'event 1',
      :description => 'an event for fb_graph test',
      :start_time => '2010-03-14T21:00:00+0000',
      :end_time => '2010-03-15T00:30:00+0000',
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
      :updated_time => '2010-01-02T15:37:41+0000',
      :ticket_uri => 'http://test.smart.fm/tickets',
    }
  end
  let(:event) { FbGraph::Event.new(attributes.delete(:id), attributes) }

  describe '.new' do
    it 'should setup all supported attributes' do
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
      event.ticket_uri.should   == 'http://test.smart.fm/tickets'
    end
  end

  describe '#update' do
    it 'should update existing event' do
      lambda do
        event.update(:location => 'Kyoto', :access_token => 'access_token')
      end.should request_to('12345', :post)
    end
  end

  context 'when venue is a page' do
    it 'should use FbGraph::Page instead of FbGraph::Venue' do
      mock_graph :get, 'event_id', 'events/with_venue_as_page', :access_token => 'access_token' do
        event = FbGraph::Event.fetch('event_id', :access_token => 'access_token')
        event.venue.should be_instance_of FbGraph::Page
      end
    end
  end
end
