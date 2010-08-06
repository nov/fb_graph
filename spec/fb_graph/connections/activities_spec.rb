require File.join(File.dirname(__FILE__), '../../spec_helper')

context 'when included by FbGraph::User' do
  describe FbGraph::Connections::Activities, '#activities' do
    before(:all) do
      fake_json(:get, 'arjun/activities', 'users/activities/arjun_public')
      fake_json(:get, 'arjun/activities?access_token=access_token', 'users/activities/arjun_private')
    end

    context 'when no access_token given' do
      it 'should raise FbGraph::Unauthorized' do
        lambda do
          FbGraph::User.new('arjun').activities
        end.should raise_exception(FbGraph::Unauthorized)
      end
    end

    context 'when access_token is given' do
      it 'should return activities as FbGraph::Page' do
        activities = FbGraph::User.new('arjun', :access_token => 'access_token').activities
        activities.class.should == FbGraph::Connection
        activities.first.should == FbGraph::Page.new(
          '378209722137',
          :access_token => 'access_token',
          :name => 'Doing Things at the Last Minute',
          :category => '活動'
        )
        activities.each do |activity|
          activity.should be_instance_of(FbGraph::Page)
        end
      end
    end
  end
end
