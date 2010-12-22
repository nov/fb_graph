require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::FriendList, '.new' do

  it 'should setup all supported attributes' do
    attributes = {
      :id => '12345',
      :name => 'My List'
    }
    video = FbGraph::FriendList.new(attributes.delete(:id), attributes)
    video.identifier.should == '12345'
    video.name.should       == 'My List'
  end

end