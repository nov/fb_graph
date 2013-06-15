require 'spec_helper'

describe FbGraph::Collection, '.new' do

  it 'should return an array with pagination info' do
    mock_graph :get, 'platform/statuses', 'pages/statuses/platform_private', :access_token => 'access_token' do
      collection = FbGraph::Page.new('platform', :access_token => 'access_token').statuses.collection
      collection.should be_kind_of(Array)
      collection.previous.should be_kind_of(Hash)
      collection.next.should be_kind_of(Hash)
    end
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

  it 'should handle paging params' do
    mock_graph :get, 'post_id/comments', 'posts/comments/with_paging_params' do
      comments = FbGraph::Post.new('post_id').comments
      comments.should be_instance_of FbGraph::Connection
      comments.should be_a FbGraph::Collection
      comments.collection.next.should include :limit, :offset, :__after_id
      comments.collection.previous.should include :limit, :offset, :__before_id
      comments.collection.cursors.should be_empty
    end
  end

  it 'should handle paging params when array of ids is passed' do
    params = {:campaign_ids => "[6001111111467]", :include_deleted => "true"}
    mock_graph :get, '100111111111121/adgroups', 'ad_groups/test_ad_group_with_paging', :params => params do
      ad_groups = FbGraph::AdAccount.new(100111111111121).ad_groups(params)
      ad_groups.should be_instance_of FbGraph::Connection
      ad_groups.should be_a FbGraph::Collection

      ad_groups.collection.next.should include :offset, :campaign_ids
      ad_groups.collection.next[:offset].should == "100"
      ad_groups.collection.next[:campaign_ids].should == '["6001111111467"]'

      ad_groups.collection.previous.should include :offset, :campaign_ids
      ad_groups.collection.previous[:offset].should == "0"
      ad_groups.collection.previous[:campaign_ids].should == '["6001111111467"]'
    end
  end

  it 'should handle cursor paging params' do
    mock_graph :get, 'post_id/comments', 'posts/comments/with_cursor_paging_params' do
      comments = FbGraph::Post.new('post_id').comments
      comments.should be_instance_of FbGraph::Connection
      comments.should be_a FbGraph::Collection
      comments.collection.next.should include :limit, :after
      comments.collection.previous.should include :limit, :before
      comments.collection.cursors.should include :before, :after
    end
  end
end
