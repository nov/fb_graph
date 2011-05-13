require 'spec_helper'

describe FbGraph::Connections::Movies, '#movies' do
  it 'should return movies pages as FbGraph::Page' do
    mock_graph :get, 'matake/movies', 'users/movies/matake_private', :access_token => 'access_token' do
      pages = FbGraph::User.new('matake', :access_token => 'access_token').movies
      pages.each do |page|
        page.should be_instance_of(FbGraph::Page)
      end
    end
  end
end