module FbGraph
  class Comment < Node
    attr_accessor :from, :message, :created_time

    def initialize(identifier, options = {})
      super
      if (from = options[:from])
        @from = if from[:category]
          FbGraph::Page.new(from.delete(:id), from) 
        else
          FbGraph::User.new(from.delete(:id), from) 
        end
      end
      @message      = options[:message]
      @created_time = options[:created_time]
    end
  end
end