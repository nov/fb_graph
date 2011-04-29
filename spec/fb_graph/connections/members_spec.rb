require 'spec_helper'

describe FbGraph::Connections::Friends, '#friends' do
  it 'should return members as FbGraph::User' do
    mock_graph :get, 'emacs/members', 'groups/members/emacs_private', :params => {
      :access_token => 'access_token'
    } do
      users = FbGraph::Group.new('emacs', :access_token => 'access_token').members
      users.each do |user|
        user.should be_instance_of(FbGraph::User)
      end
    end
  end
end