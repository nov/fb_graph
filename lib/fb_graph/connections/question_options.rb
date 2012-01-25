module FbGraph
  module Connections
    module QuestionOptions
      def question_options(opts = {})
        question_options = self.connection :question_options, opts
        question_options.map! do |option|
          QuestionOption.new option[:id], option.merge(
            :access_token => opts[:access_token] || self.access_token
          )
        end
      end
    end
  end
end
