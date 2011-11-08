module FbGraph
  class Question < Node
    include Connections::QuestionOptions
    
    attr_accessor :from, :question, :created_time, :updated_time

    def initialize(identifier, attributes = {})
      super
      @from = if attributes[:from]
        User.new(attributes[:from][:id], attributes[:from])
      end
      @question = attributes[:question]
      @created_time = if attributes[:created_time]
        Time.parse(attributes[:created_time]).utc
      end
      @updated_time = if attributes[:updated_time]
        Time.parse(attributes[:updated_time]).utc
      end

      @_options_ = if attributes[:options]
        # cached options
       Collection.new(attributes[:options])
      end
    end
  end
end
