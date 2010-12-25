module FbGraph
  class Post < Node
    include Connections::Comments
    include Connections::Likes
    extend Searchable

    attr_accessor :from, :to, :message, :picture, :link, :name, :caption, :description, :source, :icon, :attribution, :actions, :like_count, :created_time, :updated_time

    def initialize(identifier, attributes = {})
      super
      if (from = attributes[:from])
        @from = if from[:category]
          Page.new(from.delete(:id), from)
        else
          User.new(from.delete(:id), from)
        end
      end
      @to = []
      if attributes[:to]
        Collection.new(attributes[:to]).each do |to|
          @to << if to[:category]
            Page.new(to.delete(:id), to)
          else
            User.new(to.delete(:id), to)
          end
        end
      end
      @message     = attributes[:message]
      @picture     = attributes[:picture]
      @link        = attributes[:link]
      @name        = attributes[:name]
      @caption     = attributes[:caption]
      @description = attributes[:description]
      @source      = attributes[:source]
      @icon        = attributes[:icon]
      @attribution = attributes[:attribution]
      @actions     = attributes[:actions]
      @like_count  = attributes[:likes]
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