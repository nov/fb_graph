require 'spec_helper'

describe FbGraph::Connections::Movies, '#movies' do
  before do
    fake_json(:get, 'matake/movies?access_token=access_token', 'users/movies/matake_private')
  end

  it 'should return movies pages as FbGraph::Page' do
    pages = FbGraph::User.new('matake', :access_token => 'access_token').movies
    pages.each do |page|
      page.should be_instance_of(FbGraph::Page)
    end
  end
end