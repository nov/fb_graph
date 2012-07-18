require 'spec_helper'

describe FbGraph::Connections::Questions do
  describe '#questions' do
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

  describe '#question!' do
    it 'should return FbGraph::Question without cached question_options collection' do
      mock_graph :post, 'me/questions', 'users/questions/created', :params => {
        :question => 'Do you like fb_graph?',
        :options => ['Yes', 'Yes!', 'Yes!!'].to_json
      }, :access_token => 'access_token' do
        question = FbGraph::User.me('access_token').question!(
          :question => 'Do you like fb_graph?',
          :options => ['Yes', 'Yes!', 'Yes!!']
        )
        question.should be_instance_of(FbGraph::Question)
        expect { question.question_options }.to request_to "#{question.identifier}/options"
      end
    end
  end
end