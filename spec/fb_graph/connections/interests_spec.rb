require 'spec_helper'

describe FbGraph::Connections::Interests, '#interests' do
  before do
    fake_json(:get, 'matake/interests?access_token=access_token', 'users/interests/matake_private')
  end

  it 'should return interests pages as FbGraph::Page' do
    pages = FbGraph::User.new('matake', :access_token => 'access_token').interests
    pages.each do |page|
      page.should be_instance_of(FbGraph::Page)
    end
  end
end