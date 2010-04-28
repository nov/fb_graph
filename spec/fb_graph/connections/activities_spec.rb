require File.join(File.dirname(__FILE__), '../../spec_helper')

describe FbGraph::Connections::Activities, '#activities' do
  describe 'when included by FbGraph::User' do
    before(:all) do
      fake_json(:get, 'arjun/activities', 'users/activities/arjun_public')
      fake_json(:get, 'arjun/activities?access_token=access_token', 'users/activities/arjun_private')
    end

    it 'should raise FbGraph::Unauthorized when no access_token given' do
      lambda do
        FbGraph::User.new('arjun').activities
      end.should raise_exception(FbGraph::Unauthorized)
    end

    it 'should return liked pages' do
      activities = FbGraph::User.new('arjun', :access_token => 'access_token').activities
      activities.first.should == FbGraph::Page.new(
        '378209722137',
        :name => 'Doing Things at the Last Minute',
        :category => '活動'
      )
      activities.each do |activity|
        activity.should be_instance_of(FbGraph::Page)
      end
    end
  end
end
