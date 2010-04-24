module FbGraph
  class Status < Node
    attr_accessor :from, :message, :updated_time

    def initialize(identifier, options = {})
      super
      if (from = options[:from])
        @from = if from[:category]
          FbGraph::Page.new(from[:id], :name => from[:name], :category => from[:category]) 
        else
          FbGraph::User.new(from[:id], :name => from[:name])
        end
      end
      @message = options[:message]
      @updated_time = options[:updated_time]
    end
  end
end