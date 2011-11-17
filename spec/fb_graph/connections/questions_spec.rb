require 'spec_helper'

describe FbGraph::Connections::Questions do
  it 'should return an Array of Questions' do
    mock_graph :get, 'me/questions', 'users/questions/sample', :access_token => 'access_token' do
      questions = FbGraph::User.me('access_token').questions
      questions.class.should == FbGraph::Connection
      questions.each do |question|
        question.should be_instance_of(FbGraph::Question)
      end
    end
  end
end