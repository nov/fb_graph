require 'spec_helper'

describe FbGraph::Connections::Threads, '#threads' do
  it 'should return threads as FbGraph::Thread' do
    mock_graph :get, 'me/threads', 'users/threads/me_private', :access_token => 'access_token' do
      threads = FbGraph::User.me('access_token').threads
      threads.each do |thread|
        thread.should be_instance_of(FbGraph::Thread)
      end
    end
  end
end