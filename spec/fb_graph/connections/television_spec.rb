require 'spec_helper'

describe FbGraph::Connections::Television, '#television' do
  before do
    fake_json(:get, 'matake/television?access_token=access_token', 'users/television/matake_private')
  end

  it 'should return television pages as FbGraph::Page' do
    pages = FbGraph::User.new('matake', :access_token => 'access_token').television
    pages.each do |page|
      page.should be_instance_of(FbGraph::Page)
    end
  end
end