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
      @message = options[:message]
      if options[:created_time]
        @created_time = Time.parse(options[:created_time])
      end
    end
  end
end