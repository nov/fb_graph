module FbGraph
  class Album < Node
    include Connections::Photos
    include Connections::Comments
    include Connections::Likes
    include Connections::Picture

    attr_accessor :from, :name, :description, :location, :link, :privacy, :count, :created_time, :updated_time, :type

    def initialize(identifier, attributes = {})
      super
      @from = if (from = attributes[:from])
        if from[:category]
          Page.new(from.delete(:id), from)
        else
          User.new(from.delete(:id), from)
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
      @type        = attributes[:type]
      
      @created_time = if attributes[:created_time]
        Time.parse(attributes[:created_time]).utc
      end
      @updated_time = if attributes[:updated_time]
        Time.parse(attributes[:updated_time]).utc
      end

      # cached connection
      @_comments_ = Collection.new(attributes[:comments])
    end
  end
end