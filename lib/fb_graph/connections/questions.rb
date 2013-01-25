module FbGraph
  module Connections
    module Questions
      def questions(options = {})
        questions = self.connection :questions, options
        questions.map! do |question|
          Question.new question[:id], question.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      def question!(options = {})
        question = post options.merge(:connection => :questions)
        Question.new question[:id], question.merge(
          :question => options[:question],
          :access_token => options[:access_token] || self.access_token
        )
      end
    end
  end
end
