module FbGraph
  class Photo < Node
    include Connections::Comments
    include Connections::Likes

    attr_accessor :from, :tags, :name, :picture, :icon, :source, :height, :width, :link, :created_time, :updated_time

    def initialize(identifier, attributes = {})
      super
      if (from = attributes[:from])
        @from = if from[:category]
          Page.new(from.delete(:id), from)
        else
          User.new(from.delete(:id), from)
        end
      end
      @tags = []
      if attributes[:tags]
        Collection.new(attributes[:tags]).each do |tag|
          @tags << Tag.new(tag)
        end
      end
      # NOTE:
      # for some reason, facebook uses different parameter names.
      # "name" in GET & "message" in POST
      @name    = attributes[:name] || attributes[:message]
      @picture = attributes[:picture]
      @icon    = attributes[:icon]
      @source  = attributes[:source]
      @height  = attributes[:height]
      @width   = attributes[:width]
      @link    = attributes[:link]
      if attributes[:created_time]
        @created_time = Time.parse(attributes[:created_time]).utc
      end
      if attributes[:updated_time]
        @updated_time = Time.parse(attributes[:updated_time]).utc
      end

      # cached connection
      @_comments_ = Collection.new(attributes[:comments])
    end
  end
end