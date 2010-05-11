module FbGraph
  class Photo < Node
    include Connections::Comments

    attr_accessor :from, :tags, :name, :picture, :source, :height, :width, :link, :created_time, :updated_time

    def initialize(identifier, options = {})
      super
      if (from = options[:from])
        @from = if from[:category]
          FbGraph::Page.new(from.delete(:id), from)
        else
          FbGraph::User.new(from.delete(:id), from)
        end
      end
      @tags = []
      if options[:tags]
        FbGraph::Collection.new(options[:tags]).each do |tag|
          @tags << FbGraph::Tag.new(tag.delete(:id), tag)
        end
      end
      # NOTE:
      # for some reason, facebook uses different parameter names.
      # "name" in GET & "message" in POST
      @name    = options[:name] || options[:message]
      @picture = options[:picture]
      @source  = options[:source]
      @height  = options[:height]
      @width   = options[:width]
      @link    = options[:link]
      if options[:created_time]
        @created_time = Time.parse(options[:created_time]).utc
      end
      if options[:updated_time]
        @updated_time = Time.parse(options[:updated_time]).utc
      end
    end
  end
end