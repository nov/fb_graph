module FbGraph
  class Status < Node
    attr_accessor :from, :message, :updated_time

    def initialize(identifier, options = {})
      super
      if options[:from]
        @from = if options[:from][:category]
          FbGraph::Page.new(options[:from][:id], :name => options[:from][:name], :category => options[:from][:category]) 
        else
          FbGraph::User.new(options[:from][:id], :name => options[:from][:name])
        end
      end
      @message = options[:message]
      @updated_time = options[:updated_time]
    end
  end
end