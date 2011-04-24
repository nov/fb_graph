require 'spec_helper'

describe FbGraph::Connections::Activities, '#activities' do
  before do
    fake_json(:get, 'matake/games?access_token=access_token', 'users/games/matake_private')
  end

  it 'should return games as FbGraph::Page' do
    games = FbGraph::User.new('matake', :access_token => 'access_token').games
    games.class.should == FbGraph::Connection
    games.first.should == FbGraph::Page.new(
      '101392683235776',
      :access_token => 'access_token',
      :name => 'FarmVille Cows',
      :category => 'Game',
      :created_time => '2011-01-05T13:37:40+0000'
    )
    games.each do |game|
      game.should be_instance_of(FbGraph::Page)
    end
  end
end
