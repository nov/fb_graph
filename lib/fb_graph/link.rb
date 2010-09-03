module FbGraph
  class Link < Node
    include Connections::Comments

    attr_accessor :from, :link, :caption, :description, :icon, :picture, :message, :created_time

    def initialize(identifier, attributes = {})
      super
      if (from = attributes[:from])
        @from = if from[:category]
          FbGraph::Page.new(from.delete(:id), from)
        else
          FbGraph::User.new(from.delete(:id), from)
        end
      end
      @link        = attributes[:link]
      @caption     = attributes[:caption]
      @description = attributes[:description]
      @icon        = attributes[:icon]
      @picture     = attributes[:picture]
      @message     = attributes[:message]
      if attributes[:created_time]
        @created_time = Time.parse(attributes[:created_time]).utc
      end
    end
  end
end