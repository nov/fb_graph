require File.join(File.dirname(__FILE__), '../../spec_helper')

describe FbGraph::Connections::Checkins, '#checkins' do
  context 'when included by FbGraph::User' do
    before do
      fake_json(:get, 'mattt/checkins', 'users/checkins/mattt_public')
      fake_json(:get, 'mattt/checkins?access_token=access_token', 'users/checkins/mattt_private')
    end

    context 'when no access_token given' do
      it 'should raise FbGraph::Unauthorized' do
        lambda do
          FbGraph::User.new('mattt').checkins
        end.should raise_exception(FbGraph::Unauthorized)
      end
    end

    context 'when access_token is given' do
      it 'should return checkins as FbGraph::Checkin' do
        checkins = FbGraph::User.new('mattt', :access_token => 'access_token').checkins
        checkins.first.should == FbGraph::Checkin.new(
          '696876187499',
          :access_token => 'access_token',
          :from => {
            :id => '12820552',
            :name => 'Roger Pincombe'
          },
          :tags => {
            :data => [{
              :id => '4810308',
              :name => 'Mattt Thompson'
            }]
          },
          :message => 'Checking out Austin, TX',
          :place => {
            :id => '120454134658381',
            :name => 'Gowalla HQ',
            :location => {
              :latitude => 30.26876,
              :longitude => -97.74962
            }
          },
          :application => {
            :id => '6628568379',
            :name => 'Facebook for iPhone'
          },
          :created_time => '2010-09-08T00:09:25+0000'
        )
        checkins.each do |checkin|
          checkin.should be_instance_of(FbGraph::Checkin)
        end
      end
    end
  end

  context 'when included by FbGraph::Page' do
    before do
      fake_json(:get, 'gowalla/checkins', 'pages/checkins/gowalla_public')
      fake_json(:get, 'gowalla/checkins?access_token=access_token', 'pages/checkins/gowalla_private')
    end

    context 'when no access_token given' do
      it 'should raise FbGraph::Unauthorized' do
        lambda do
          FbGraph::Page.new('gowalla').checkins
        end.should raise_exception(FbGraph::Unauthorized)
      end
    end

    context 'when access_token is given' do
      it 'should return checkins as FbGraph::Checkin' do
        checkins = FbGraph::Page.new('gowalla', :access_token => 'access_token').checkins
        checkins.first.should == FbGraph::Checkin.new(
          '696876187499',
          :access_token => 'access_token',
          :from => {
            :id => '12820552',
            :name => 'Roger Pincombe'
          },
          :tags => {
            :data => [{
              :id => '4810308',
              :name => 'Mattt Thompson'
            }]
          },
          :message => 'Checking out Austin, TX',
          :place => {
            :id => '120454134658381',
            :name => 'Gowalla HQ',
            :location => {
              :latitude => 30.26876,
              :longitude => -97.74962
            }
          },
          :application => {
            :id => '6628568379',
            :name => 'Facebook for iPhone'
          },
          :created_time => '2010-09-08T00:09:25+0000'
        )
        checkins.each do |checkin|
          checkin.should be_instance_of(FbGraph::Checkin)
        end
      end
    end
  end
end
