require File.join(File.dirname(__FILE__), '../../spec_helper')

describe FbGraph::Connections::Events, '#events' do
  describe 'when included by FbGraph::User' do
    before(:all) do
      fake_json(:get, 'matake/events', 'users/events/matake_public')
      fake_json(:get, 'matake/events?token=token', 'users/events/matake_private')
    end

    it 'should raise FbGraph::Unauthorized when no token given' do
      lambda do
        FbGraph::User.new('matake').events
      end.should raise_exception(FbGraph::Unauthorized)
    end

    it 'should return public own posts even when token is not given' do
      events = FbGraph::User.new('matake', :token => 'token').events
      events.first.should == FbGraph::Event.new(
        '116600818359630',
        :name => 'The Loyal We @ Rainy Day Bookstore and Cafe',
        :start_time => '2010-04-29T01:30:00+0000',
        :end_time => '2010-04-29T04:30:00+0000',
        :location => 'Nishi Azabu'
      )
      events.each do |event|
        event.should be_instance_of(FbGraph::Event)
      end
    end

  end
end