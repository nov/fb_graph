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
      if options[:created_time]
        @created_time = Time.parse(options[:created_time])
      end
      if options[:updated_time]
        @updated_time = Time.parse(options[:updated_time])
      end
    end
  end
end