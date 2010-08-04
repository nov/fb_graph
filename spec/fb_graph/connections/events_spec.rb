require File.join(File.dirname(__FILE__), '../../spec_helper')

context 'when included by FbGraph::User' do
  describe FbGraph::Connections::Events, '#events' do
    before(:all) do
      fake_json(:get, 'matake/events', 'users/events/matake_public')
      fake_json(:get, 'matake/events?access_token=access_token', 'users/events/matake_private')
    end

    context 'when no access_token given' do
      it 'should raise FbGraph::Unauthorized' do
        lambda do
          FbGraph::User.new('matake').events
        end.should raise_exception(FbGraph::Unauthorized)
      end
    end

    context 'when access_token is given' do
      it 'should return events as FbGraph::Event' do
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

  describe FbGraph::Connections::Events, '#events!' do
    before do
      fake_json(:post, 'matake/events', 'users/events/post_with_valid_access_token')
    end

    it 'should return generated note' do
      puts Time.utc(2010,5,11,9,0).to_i
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