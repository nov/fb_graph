module FbGraph
  class Post < Node
    include Connections::Comments
    include Connections::Likes
    extend Searchable

    attr_accessor :from, :to, :message, :picture, :link, :name, :caption, :description, :source, :icon, :attribution, :actions, :type, :privacy, :targeting, :created_time, :updated_time

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
          elsif to[:start_time]
            Event.new(to.delete(:id), to)
          elsif to[:version]
            Group.new(to.delete(:id), to)
          else
            case attributes[:context]
            when Application
              Application.new(to.delete(:id), to)
            else
              User.new(to.delete(:id), to)
            end
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
      @actions     = []
      if attributes[:actions]
        attributes[:actions].each do |action|
          @actions << Action.new(action)
        end
      end
      @type        = attributes[:type]
      if attributes[:privacy]
        @privacy = if attributes[:privacy].is_a?(Privacy)
          attributes[:privacy]
        else
          Privacy.new(attributes[:privacy])
        end
      end
      if attributes[:targeting]
        @targeting = if attributes[:targeting].is_a?(Targeting)
          attributes[:targeting]
        else
          Targeting.new(attributes[:targeting])
        end
      end
      if attributes[:created_time]
        @created_time = Time.parse(attributes[:created_time]).utc
      end
      if attributes[:updated_time]
        @updated_time = Time.parse(attributes[:updated_time]).utc
      end

      # cached connection
      @_likes_ = Collection.new(attributes[:likes])
      @_comments_ = Collection.new(attributes[:comments])
    end
  end
end