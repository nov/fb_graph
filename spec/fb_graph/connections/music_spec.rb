require 'spec_helper'

describe FbGraph::Connections::Music, '#music' do
  it 'should return music pages as FbGraph::Page' do
    mock_graph :get, 'matake/music', 'users/music/matake_private', :access_token => 'access_token' do
      pages = FbGraph::User.new('matake', :access_token => 'access_token').music
      pages.each do |page|
        page.should be_instance_of(FbGraph::Page)
      end
    end
  end
end