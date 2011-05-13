require 'spec_helper'

describe FbGraph::Connections::Television, '#television' do
  it 'should return television pages as FbGraph::Page' do
    mock_graph :get, 'matake/television', 'users/television/matake_private', :access_token => 'access_token' do
      pages = FbGraph::User.new('matake', :access_token => 'access_token').television
      pages.each do |page|
        page.should be_instance_of(FbGraph::Page)
      end
    end
  end
end