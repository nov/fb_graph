require 'spec_helper'

describe FbGraph::Connections::Events, '#events' do
  context 'when included by FbGraph::User' do
    context 'when no access_token given' do
      it 'should raise FbGraph::Unauthorized' do
        mock_graph :get, 'matake/events', 'users/events/matake_public', :status => [401, 'Unauthorized'] do
          lambda do
            FbGraph::User.new('matake').events
          end.should raise_exception(FbGraph::Unauthorized)
        end
      end
    end

    context 'when access_token is given' do
      it 'should return events as FbGraph::Event' do
        mock_graph :get, 'matake/events', 'users/events/matake_private', :access_token => 'access_token' do
          events = FbGraph::User.new('matake', :access_token => 'access_token').events
          events.first.should == FbGraph::Event.new(
            '116600818359630',
            :access_token => 'access_token',
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
  end
end

describe FbGraph::Connections::Events, '#events!' do
  context 'when included by FbGraph::User' do
    it 'should return generated note' do
      mock_graph :post, 'matake/events', 'users/events/post_with_valid_access_token' do
        event = FbGraph::User.new('matake', :access_token => 'valid').event!(
          :name => 'FbGraph test event',
          :start_time => Time.utc(2010, 5, 11, 10, 0, 0).to_i,
          :end_time   => Time.utc(2010, 5, 11, 12, 0, 0).to_i
        )
        event.name.should == 'FbGraph test event'
        event.access_token.should == 'valid'
        event.start_time.should == Time.utc(2010, 5, 11, 10, 0, 0)
        event.end_time.should == Time.utc(2010, 5, 11, 12, 0, 0)
      end
    end
  end
end