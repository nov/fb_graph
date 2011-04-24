require 'spec_helper'

describe FbGraph::Connections::Friends, '#friends' do
  before do
    fake_json(:get, 'emacs/members?access_token=access_token', 'groups/members/emacs_private')
  end

  it 'should return members as FbGraph::User' do
    users = FbGraph::Group.new('emacs', :access_token => 'access_token').members
    users.each do |user|
      user.should be_instance_of(FbGraph::User)
    end
  end
end