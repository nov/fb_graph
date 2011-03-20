module FbGraph
  class Checkin < Node
    extend Searchable

    attr_accessor :from, :tags, :place, :message, :application, :created_time

    def initialize(identifier, attributes = {})
      super
      if (from = attributes[:from])
        @from = User.new(from.delete(:id), from)
      end
      @tags = []
      if (tags = attributes[:tags])
        Collection.new(tags).each do |user|
          @tags << User.new(user.delete(:id), user)
        end
      end
      if (place = attributes[:place])
        @place = case place
        when Place
          place
        when String, Integer
          Place.new(place)
        when Hash
          Place.new(place.delete(:id), place)
        end
      end
      @message = attributes[:message]
      if (application = attributes[:application])
        @application = Application.new(application.delete(:id), application)
      end
      if (created_time = attributes.delete(:created_time))
        @created_time = Time.parse(created_time).utc
      end
    end

    def self.search(options = {})
      super(nil, options)
    end
  end
end