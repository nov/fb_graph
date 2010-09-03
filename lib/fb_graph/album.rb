module FbGraph
  class Album < Node
    include Connections::Photos
    include Connections::Comments
    include Connections::Likes

    attr_accessor :from, :name, :description, :location, :link, :privacy, :count, :created_time, :updated_time

    def initialize(identifier, attributes = {})
      super
      if (from = attributes[:from])
        @from = if from[:category]
          FbGraph::Page.new(from.delete(:id), from)
        else
          FbGraph::User.new(from.delete(:id), from)
        end
      end
      @name = attributes[:name]
      # NOTE:
      # for some reason, facebook uses different parameter names.
      # "description" in GET & "message" in POST
      # TODO:
      # check whether this issue is solved or not
      @description = attributes[:description] || attributes[:message]
      @location    = attributes[:location]
      @link        = attributes[:link]
      @privacy     = attributes[:privacy]
      @count       = attributes[:count]
      if attributes[:created_time]
        @created_time = Time.parse(attributes[:created_time]).utc
      end
      if attributes[:updated_time]
        @updated_time = Time.parse(attributes[:updated_time]).utc
      end

      # cached connection
      @_comments_ = FbGraph::Collection.new(attributes[:comments])
    end
  end
end