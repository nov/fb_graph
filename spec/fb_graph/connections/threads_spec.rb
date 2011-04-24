require 'spec_helper'

describe FbGraph::Connections::Threads, '#threads' do
  before do
    fake_json(:get, 'me/threads?access_token=access_token', 'users/threads/me_private')
  end

  it 'should return threads as FbGraph::Thread' do
    threads = FbGraph::User.me('access_token').threads
    threads.each do |thread|
      thread.should be_instance_of(FbGraph::Thread)
    end
  end
end