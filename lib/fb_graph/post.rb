module FbGraph
  class Post < Node
    include Connections::Comments
    include Connections::Insights
    include Connections::Likes
    include Connections::Likes::Likable
    extend Searchable

    ATTRS = [
      :message,
      :picture,
      :link,
      :name,
      :caption,
      :description,
      :source,
      :icon,
      :type,
      :graph_object_id,
      :story
    ]

    COMPLEX_ATTRS = [
      :from,
      :to,
      :with_tags,
      :message_tags,
      :properties,
      :actions,
      :privacy,
      :application,
      :targeting,
      :created_time,
      :updated_time,
      :story_tags,
      :place,
      :images
    ]

    attr_accessor *ATTRS 
    attr_accessor *COMPLEX_ATTRS 
    def initialize(identifier, attributes = {})
      super
      set_attrs(attributes)
      # cached connection
      cache_collections attributes, :comments, :likes
    end

    protected

    def set_attrs(attributes)
      COMPLEX_ATTRS.each do |field|
        send("set_attr_#{field}", attributes)
      end
      ATTRS.each do |field|
        send("#{field}=", attributes[field.to_sym])
      end
      @graph_object_id = attributes[:object_id]
    end

    def set_attr_from(attributes)
      if (from = attributes[:from])
        @from = if from[:category]
          Page.new(from[:id], from)
        else
          User.new(from[:id], from)
        end
      end
    end

    def set_attr_to(attributes)
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
    end

    def set_attr_with_tags(attributes)
      @with_tags = []
      if attributes[:with_tags]
        Collection.new(attributes[:with_tags]).each do |tagged|
          @with_tags << User.new(tagged[:id], tagged)
        end
      end
    end

    def set_attr_message_tags(attributes)
      @message_tags = []
      if (message_tags = attributes[:message_tags])
        message_tags.each do |index, message_tag|
          message_tag.each do |_message_tag_|
            @message_tags << TaggedObject.new(_message_tag_[:id], _message_tag_)
          end
        end
      end
    end

    def set_attr_properties(attributes)
      @properties = []
      if attributes[:properties]
        attributes[:properties].each do |property|
          @properties << Property.new(property)
        end
      end
    end

    def set_attr_actions(attributes)
      @actions = []
      if attributes[:actions]
        attributes[:actions].each do |action|
          @actions << Action.new(action)
        end
      end
    end

    def set_attr_privacy(attributes)
      if attributes[:privacy]
        @privacy = if attributes[:privacy].is_a?(Privacy)
          attributes[:privacy]
        else
          Privacy.new(attributes[:privacy])
        end
      end
    end

    def set_attr_application(attributes)
      if attributes[:application]
        @application = Application.new(attributes[:application][:id], attributes[:application])
      end
    end

    def set_attr_targeting(attributes)
      if attributes[:targeting]
        @targeting = if attributes[:targeting].is_a?(Targeting)
          attributes[:targeting]
        else
          Targeting.new(attributes[:targeting])
        end
      end
    end

    def set_attr_created_time(attributes)
      if attributes[:created_time]
        @created_time = Time.parse(attributes[:created_time]).utc
      end
    end

    def set_attr_updated_time(attributes)
      if attributes[:updated_time]
        @updated_time = Time.parse(attributes[:updated_time]).utc
      end
    end

    def set_attr_story_tags(attributes)
      @story_tags = []
      if story_tags = attributes[:story_tags]
        story_tags.each do |index, story_tag|
          story_tag.each do |_story_tag_|
            @story_tags << TaggedObject.new(_story_tag_[:id], _story_tag_)
          end
        end
      end
    end

    def set_attr_place(attributes)
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
    end

    def set_attr_images(attributes)
      @images = []
      if attributes[:images]
        attributes[:images].each do |image|
          @images << Image.new(image)
        end
      end
    end

  end
end