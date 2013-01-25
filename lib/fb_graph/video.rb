module FbGraph
  class Video < Node
    include Connections::Comments
    include Connections::Likes
    include Connections::Likes::Likable
    include Connections::Picture

    attr_accessor :from, :tags, :name, :description, :embed_html, :icon, :source, :created_time, :updated_time

    def initialize(identifier, attributes = {})
      super
      if (from = attributes[:from])
        @from = if from[:category]
          Page.new(from[:id], from)
        else
          User.new(from[:id], from)
        end
      end
      @tags = []
      if attributes[:tags]
        Collection.new(attributes[:tags]).each do |tag|
          @tags << Tag.new(tag)
        end
      end
      @name        = attributes[:name]
      @description = attributes[:description]
      @embed_html  = attributes[:embed_html]
      @icon        = attributes[:icon]
      @source      = attributes[:source]
      if attributes[:created_time]
        @created_time = Time.parse(attributes[:created_time]).utc
      end
      if attributes[:updated_time]
        @updated_time = Time.parse(attributes[:updated_time]).utc
      end

      # cached connection
      cache_collections attributes, :comments
    end
  end
end