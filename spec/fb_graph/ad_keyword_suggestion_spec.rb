require 'spec_helper'

describe FbGraph::AdKeywordSuggestion, '.search' do
  it 'should perform a search' do
    mock_graph :get, 'search', 'ad_keyword_suggestions/buffy_suggestions', :params => {:keyword_list => 'buffy+the+vampire+slayer', :type => 'adkeywordsuggestion'} do
      ad_keywords = FbGraph::AdKeywordSuggestion.search('buffy+the+vampire+slayer')

      ad_keywords.size.should == 8
      ad_keywords.each {|kw| kw.should be_instance_of(FbGraph::AdKeywordSuggestion)}
      ad_keywords.first.should == FbGraph::AdKeywordSuggestion.new(
        6003134100700,
        :name => "#Angel (TV series)",
        :description => "Audience: 675,000"
      )
    end
  end
end
