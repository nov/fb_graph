require 'spec_helper'

describe FbGraph::Connections::Interests, '#interests' do
  it 'should return interests pages as FbGraph::Page' do
    mock_graph :get, 'matake/interests', 'users/interests/matake_private', :access_token => 'access_token' do
      pages = FbGraph::User.new('matake', :access_token => 'access_token').interests
      pages.each do |page|
        page.should be_instance_of(FbGraph::Page)
      end
    end
  end
end