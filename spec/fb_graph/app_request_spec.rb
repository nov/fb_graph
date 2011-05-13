require 'spec_helper'

describe FbGraph::AppRequest, '.new' do
  it 'should setup all supported attributes' do
    attributes = {
      :id => "10150111088582277",
      :application => {
        :name => "gem sample",
        :id => "134145643294322"
      },
      :to => {
        :name => "Nov Matake",
        :id => "579612276"
      },
      :from => {
        :name => "Nov Matake",
        :id => "1575327134"
      },
      :data => "tracking information for the user",
      :message => "You should learn more about this awesome game.",
      :created_time => "2011-02-04T09:55:43+0000"
    }
    app_request = FbGraph::AppRequest.new(attributes.delete(:id), attributes)
    app_request.identifier.should == '10150111088582277'
    app_request.application.should == FbGraph::Application.new('134145643294322', :name => 'gem sample')
    app_request.to.should == FbGraph::User.new('579612276', :name => 'Nov Matake')
    app_request.from.should == FbGraph::User.new('1575327134', :name => 'Nov Matake')
    app_request.data.should == 'tracking information for the user'
    app_request.message.should == 'You should learn more about this awesome game.'
    app_request.created_time.should == Time.parse('2011-02-04T09:55:43+0000')
  end
end

describe FbGraph::AppRequest, '#destroy' do
  it 'should request DELETE /:request_id' do
    mock_graph :delete, '12345', 'true', :access_token => 'access_token' do
      FbGraph::AppRequest.new('12345', :access_token => 'access_token').destroy
    end
  end
end
