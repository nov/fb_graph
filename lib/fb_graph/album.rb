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
      # NOTE:
      # for some reason, facebook uses different parameter names.
      # "description" in GET & "message" in POST
      @description  = options[:description] || options[:message]
      @location     = options[:location]
      @link         = options[:link]
      @count        = options[:count]
      if options[:created_time]
        @created_time = Time.parse(options[:created_time]).utc
      end
      if options[:updated_time]
        @updated_time = Time.parse(options[:updated_time]).utc
      end
    end
  end
end