module FbGraph
  class Post < Node
    include Connections::Comments

    attr_accessor :from, :to, :message, :picture, :link, :name, :caption, :description, :source, :icon, :attribution, :actions, :likes, :created_time, :updated_time

    def initialize(identifier, options = {})
      super
      if (from = options[:from])
        @from = if from[:category]
          FbGraph::Page.new(from.delete(:id), from)
        else
          FbGraph::User.new(from.delete(:id), from)
        end
      end
      @to = []
      if options[:to]
        FbGraph::Collection.new(options[:to]).each do |to|
          @to << if to[:category]
            FbGraph::Page.new(to.delete(:id), to)
          else
            FbGraph::User.new(to.delete(:id), to)
          end
        end
      end
      @message     = options[:message]
      @picture     = options[:picture]
      @link        = options[:link]
      @name        = options[:name]
      @caption     = options[:caption]
      @description = options[:description]
      @source      = options[:source]
      @icon        = options[:icon]
      @attribution = options[:attribution]
      @actions     = options[:actions]
      @likes       = options[:likes]
      if options[:created_time]
        @created_time = Time.parse(options[:created_time])
      end
      if options[:updated_time]
        @updated_time = Time.parse(options[:updated_time])
      end

      # cached connection
      @_comments_ = FbGraph::Collection.new(options[:comments])
    end
  end
end