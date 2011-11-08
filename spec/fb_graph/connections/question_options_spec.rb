require 'spec_helper'

describe FbGraph::Connections::QuestionOptions, '#options' do
  context 'when included by FbGraph::Question' do
    it 'should return options as FbGraph::QuestionOption' do
      mock_graph :get, '12345/question_options', 'questions/options/matake_private', :access_token => 'access_token' do
        options = FbGraph::Question.new('12345', :access_token => 'access_token').options
        options.each do |option|
          option.should be_instance_of(FbGraph::QuestionOption)
        end
      end
    end
  end
end
