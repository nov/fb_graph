require 'spec_helper'

describe FbGraph::Connections::Outbox, '#outbox' do
  # NOTE:
  #  This connection returns Post instead of Thread for now.
  #  See outbox.rb for more details.
  it 'should return threads as FbGraph::Post' do
    mock_graph :get, 'me/outbox', 'users/outbox/me_private', :access_token => 'access_token' do
      threads = FbGraph::User.me('access_token').outbox
      threads.each do |thread|
        thread.should be_instance_of(FbGraph::Post)
      end
    end
  end
end