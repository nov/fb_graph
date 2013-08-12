module FbGraph
  class Post < Node
    include Connections::Comments
    include Connections::Insights
    include Connections::Likes
    include Connections::Likes::Likable
    extend Searchable

    attr_accessor :from, :to, :with_tags, :message, :message_tags, :picture, :link, :name, :caption, :description, :source, :properties, :icon, :actions, :privacy, :type, :graph_object_id, :application, :targeting, :created_time, :updated_time, :story, :story_tags, :place

    def initialize(identifier, attributes = {})
      super
      if (from = attributes[:from])
        @from = if from[:category]
          Page.new(from[:id], from)
        else
          User.new(from[:id], from)
        end
      end
      @to = []
      if attributes[:to]
        Collection.new(attributes[:to]).each do |to|
          @to << if to[:category]
            Page.new(to[:id], to)
          elsif to[:start_time]
            Event.new(to[:id], to)
          elsif to[:version]
            Group.new(to[:id], to)
          elsif to[:namespace]
            Application.new(to[:id], to)
          else
            User.new(to[:id], to)
          end
        end
      end
      @with_tags = []
      if attributes[:with_tags]
        Collection.new(attributes[:with_tags]).each do |tagged|
          @with_tags << User.new(tagged[:id], tagged)
        end
      end
      @message = attributes[:message]
      @message_tags = []
      if (message_tags = attributes[:message_tags])
        message_tags.each do |index, message_tag|
          message_tag.each do |_message_tag_|
            @message_tags << TaggedObject.new(_message_tag_[:id], _message_tag_)
          end
        end
      end
      @picture     = attributes[:picture]
      @link        = attributes[:link]
      @name        = attributes[:name]
      @caption     = attributes[:caption]
      @description = attributes[:description]
      @source      = attributes[:source]
      @properties = []
      if attributes[:properties]
        attributes[:properties].each do |property|
          @properties << Property.new(property)
        end
      end
      @icon = attributes[:icon]
      @actions = []
      if attributes[:actions]
        attributes[:actions].each do |action|
          @actions << Action.new(action)
        end
      end
      if attributes[:privacy]
        @privacy = if attributes[:privacy].is_a?(Privacy)
          attributes[:privacy]
        else
          Privacy.new(attributes[:privacy])
        end
      end
      @type = attributes[:type]
      @graph_object_id = attributes[:object_id]
      if attributes[:application]
        @application = Application.new(attributes[:application][:id], attributes[:application])
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
      @story = attributes[:story]
      @story_tags = []
      if story_tags = attributes[:story_tags]
        story_tags.each do |index, story_tag|
          story_tag.each do |_story_tag_|
            @story_tags << TaggedObject.new(_story_tag_[:id], _story_tag_)
          end
        end
      end
      if (place = attributes[:place])
        @place = case place
        when Place
          place
        when String, Integer
          Place.new(place)
        when Hash
          Place.new(place[:id], place)
        end
      end

      # cached connection
      cache_collections attributes, :comments, :likes
    end
  end
end