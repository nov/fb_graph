module FbGraph
  class Video < Node
    include Connections::Comments

    attr_accessor :from, :message, :description, :length, :created_time, :updated_time

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
      @description  = options[:description]
      @length       = options[:length]
      @created_time = options[:created_time]
      @updated_time = options[:updated_time]
    end
  end
end