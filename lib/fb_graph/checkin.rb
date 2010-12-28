module FbGraph
  class Checkin < Node
    extend Searchable

    attr_accessor :from, :tags, :place, :message, :coordinates, :application, :created_time

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
        @place = Place.new(place.delete(:id), place)
      end
      @message = attributes[:message]
      if (coordinates = attributes[:coordinates])
        # NOTE: it seems this attributes isn't used now
        @coordinates = Location.new(location)
      end
      if (application = attributes[:application])
        @application = Application.new(application.delete(:id), application)
      end
      if (created_time = attributes.delete(:created_time))
        @created_time = Time.parse(created_time).utc
      end
    end

    # == Search for recent check-ins for an authorized user and his or her friends:
    # 
    #   FbGraph::Checkin.search(:access_token => ACCESS_TOKEN)
    #   # => Array of FbGraph::Checkin
    def self.search(options = {})
      # NOTE:
      # checkin search doesn't support "q=***" parameter
      super(nil, options)
    end
  end
end