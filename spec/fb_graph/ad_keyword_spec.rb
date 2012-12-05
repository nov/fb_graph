require 'spec_helper'

describe FbGraph::AdKeyword, '.search' do
  it 'should perform a search' do
    mock_graph :get, 'search', 'ad_keywords/buffy_search', :params => {:q => 'buffy', :type => 'adkeyword'} do
      ad_keywords = FbGraph::AdKeyword.search('buffy')

      ad_keywords.size.should == 8
      ad_keywords.each {|kw| kw.should be_instance_of(FbGraph::AdKeyword)}
      ad_keywords.first.should == FbGraph::AdKeyword.new(
        6003357305127,
        :name => "#Buffy the Vampire Slayer (TV series)",
        :description => "Audience: 1,300,000"
      )
    end
  end
end

describe FbGraph::AdKeyword, '.topic_keyword?' do
  it 'should be true for topic keywords' do
    FbGraph::AdKeyword.new(12345, {:name => "#Topics Have Hashes", :description => "Audience: 1,000"}).topic_keyword?.should be_true
  end

  it "should be false for non-topic keywords" do
    FbGraph::AdKeyword.new(12345, {:name => "No Hash Here"}).topic_keyword?.should be_false
  end
end
