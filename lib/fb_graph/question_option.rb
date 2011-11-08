module FbGraph
  class QuestionOption < Node
    include Connections::Votes

    attr_accessor :from, :name, :votes, :object, :created_time

    def initialize(identifier, attributes = {})
      super
      @from = if attributes[:from]
        User.new(attributes[:from][:id], attributes[:from])
      end
      @name = attributes[:name]
      @votes = attributes[:votes]
      @object = if attributes[:object]
        Page.new(attributes[:object][:id], attributes[:object])
      end
      @created_time = if attributes[:created_time]
        Time.parse(attributes[:created_time]).utc
      end
    end
  end
end
