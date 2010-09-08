module FbGraph
  class Checkin < Node
    extend Searchable

    attr_accessor :from, :tags, :place, :message, :coordinates, :application, :created_time

    def initialize(identifier, attributes = {})
      super
      if (from = attributes[:from])
        @from = FbGraph::User.new(from.delete(:id), from)
      end
      @tags = []
      if (tags = attributes[:tags])
        FbGraph::Collection.new(tags).each do |user|
          @tags << FbGraph::User.new(user.delete(:id), user)
        end
      end
      if (location = attributes[:location])
        @location = FbGraph::Page.new(location.delete(:id), location)
      end
      @message = attributes[:message]
      if (coordinates = attributes[:coordinates])
        # NOTE: it seems this attributes isn't used now
        @coordinates = FbGraph::Venue.new(location)
      end
      if (application = attributes[:application])
        @application = FbGraph::Application.new(application.delete(:id), application)
      end
      if (created_time = attributes.delete(:created_time))
        @created_time = Time.parse(created_time).utc
      end
    end

    def search(options = {})
      # NOTE:
      # checkin search doesn't support "q=***" parameter
      super(nil, options)
    end
  end
end