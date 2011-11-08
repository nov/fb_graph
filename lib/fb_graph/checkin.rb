module FbGraph
  class Checkin < Node
    include Connections::Comments
    include Connections::Likes
    include Connections::Likes::Likable
    extend Searchable

    attr_accessor :from, :tags, :place, :message, :application, :created_time

    def initialize(identifier, attributes = {})
      super
      if (from = attributes[:from])
        @from = User.new(from[:id], from)
      end
      @tags = []
      if (tags = attributes[:tags])
        case tags
        when Hash
          Collection.new(tags).each do |user|
            @tags << User.new(user[:id], user)
          end
        when String, Array
          Array(tags).each do |user_id|
            @tags << User.new(user_id)
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
      @message = attributes[:message]
      if (application = attributes[:application])
        @application = Application.new(application[:id], application)
      end
      if (created_time = attributes[:created_time])
        @created_time = Time.parse(created_time).utc
      end
    end

    def self.search(options = {})
      super(nil, options)
    end
  end
end