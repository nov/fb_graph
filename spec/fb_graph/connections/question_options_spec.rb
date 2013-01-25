require 'spec_helper'

describe FbGraph::Connections::QuestionOptions, '#options' do
  context 'when included by FbGraph::Question' do
    it 'should return options as FbGraph::QuestionOption' do
      mock_graph :get, '12345/options', 'questions/options/matake_private', :access_token => 'access_token' do
        question_options = FbGraph::Question.new('12345', :access_token => 'access_token').question_options
        question_options.each do |question_option|
          question_option.should be_instance_of(FbGraph::QuestionOption)
        end
      end
    end
  end
end
