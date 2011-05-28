module FbGraph
  class Photo < Node
    include Connections::Comments
    include Connections::Likes
    include Connections::Picture
    include Connections::Tags
    include Connections::Tags::Taggable

    attr_accessor :from, :name, :icon, :source, :height, :width, :images, :link, :created_time, :updated_time, :position

    def initialize(identifier, attributes = {})
      super
      if (from = attributes[:from])
        @from = if from[:category]
          Page.new(from[:id], from)
        else
          User.new(from[:id], from)
        end
      end
      # NOTE:
      # for some reason, facebook uses different parameter names.
      # "name" in GET & "message" in POST
      @name     = attributes[:name] || attributes[:message]
      @icon     = attributes[:icon]
      @source   = attributes[:source]
      @height   = attributes[:height]
      @width    = attributes[:width]
      @link     = attributes[:link]
      @position = attributes[:position]
      @images = []
      if attributes[:images]
        attributes[:images].each do |image|
          @images << Image.new(image)
        end
      end
      if attributes[:created_time]
        @created_time = Time.parse(attributes[:created_time]).utc
      end
      if attributes[:updated_time]
        @updated_time = Time.parse(attributes[:updated_time]).utc
      end

      # cached connection
      @_tags_ = Collection.new(attributes[:tags])
      @_comments_ = Collection.new(attributes[:comments])
    end
  end
end