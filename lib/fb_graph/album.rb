module FbGraph
  class Album < Node
    include Connections::Photos
    include Connections::Comments

    attr_accessor :from, :name, :description, :location, :link, :count, :created_time, :updated_time

    def initialize(identifier, options = {})
      super
      if (from = options[:from])
        @from = if from[:category]
          FbGraph::Page.new(from.delete(:id), from) 
        else
          FbGraph::User.new(from.delete(:id), from) 
        end
      end
      @name         = options[:name]
      @description  = options[:description]
      @location     = options[:location]
      @link         = options[:link]
      @count        = options[:count]
      @created_time = options[:created_time]
      @updated_time = options[:updated_time]
    end
  end
end