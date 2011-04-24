require 'spec_helper'

describe FbGraph::Collection, '.new' do
  before do
    fake_json(:get, 'platform/statuses?access_token=access_token', 'pages/statuses/platform_private')
  end

  it 'should return an array with pagination info' do
    collection = FbGraph::Page.new('platform', :access_token => 'access_token').statuses.collection
    collection.should be_kind_of(Array)
    collection.previous.should be_kind_of(Hash)
    collection.next.should be_kind_of(Hash)
  end

  it 'should allow blank data' do
    patterns = [
      FbGraph::Collection.new,
      FbGraph::Collection.new({}),
      FbGraph::Collection.new({:count => 5}),
      FbGraph::Collection.new(nil)
    ]
    patterns.each do |collection|
      collection.should be_kind_of(Array)
      collection.previous.should be_kind_of(Hash)
      collection.next.should be_kind_of(Hash)
      collection.should be_blank
      collection.previous.should be_blank
      collection.next.should be_blank
    end
  end

  it 'should fetch count as total_count' do
    collection = FbGraph::Collection.new({:count => 5})
    collection.total_count.should == 5
  end

  it 'should accept Array' do
    collection = FbGraph::Collection.new([1, 2, 3])
    collection.total_count.should == 3
    collection.should == [1, 2, 3]
    collection.previous.should be_blank
    collection.next.should be_blank
  end

  it 'should raise error for invalid input' do
    lambda do
      FbGraph::Collection.new("STRING")
    end.should raise_error(ArgumentError, 'Invalid collection')
  end

end