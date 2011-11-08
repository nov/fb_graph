module FbGraph
  module Connections
    module QuestionOptions
      def options(opts = {})
        question_options = if @_options_ && opts.blank?
          self.connection(:question_options, opts.merge(:cached_collection => @_options_))
        else
          self.connection(:question_options, opts)
        end
        question_options.map! do |option|
          QuestionOption.new(option[:id], option.merge(
            :access_token => opts[:access_token] || self.access_token
          ))
        end
      end
    end
  end
end
