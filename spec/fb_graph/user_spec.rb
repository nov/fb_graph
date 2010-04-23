require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::User, '.me' do
  it 'should return FbGraph::User instance with access_token' do
    FbGraph::User.me('access_token').should == FbGraph::User.new('me', :access_token => 'access_token')
  end
end

describe FbGraph::User, '#profile' do
  it 'should setup profile attributes' do
    # TODO
    user = FbGraph::User.new('matake').profile
    puts user.inspect
  end
end