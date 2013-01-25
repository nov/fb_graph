module FbGraph
  module Connections
    module QuestionOptions
      def question_options(options = {})
        question_options = self.connection :options, options
        question_options.map! do |question_option|
          QuestionOption.new question_option[:id], question_option.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
    end
  end
end
