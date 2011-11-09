require 'spec_helper'

describe FbGraph::Connections::Votes, '#votes' do
  context 'when included by FbGraph::QuestionOption' do
    it 'should return votes with user id and name' do
      mock_graph :get, '12345/votes', 'questions/options/votes/matake_private', :access_token => 'access_token' do
        votes = FbGraph::QuestionOption.new('12345', :access_token => 'access_token').votes
        votes.each do |vote|
          vote["id"].should_not be_blank
          vote["name"].should_not be_blank
        end
      end
    end
  end
end
