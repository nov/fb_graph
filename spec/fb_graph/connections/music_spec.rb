require 'spec_helper'

describe FbGraph::Connections::Music, '#music' do
  before do
    fake_json(:get, 'matake/music?access_token=access_token', 'users/music/matake_private')
  end

  it 'should return music pages as FbGraph::Page' do
    pages = FbGraph::User.new('matake', :access_token => 'access_token').music
    pages.each do |page|
      page.should be_instance_of(FbGraph::Page)
    end
  end
end