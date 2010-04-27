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
      @message      = options[:message]
      @picture      = options[:picture]
      @link         = options[:link]
      @name         = options[:name]
      @caption      = options[:caption]
      @description  = options[:description]
      @source       = options[:source]
      @icon         = options[:icon]
      @attribution  = options[:attribution]
      @actions      = options[:actions]
      @likes        = options[:likes]
      @created_time = options[:created_time]
      @updated_time = options[:updated_time]
    end
  end
end