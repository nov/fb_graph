module FbGraph
  class Work
    include FbGraph::Comparison

    attr_accessor :employer, :location, :position, :start_date, :end_date

    def initialize(attributes = {})
      if (employer = attributes[:employer])
        @employer = FbGraph::Page.new(employer.delete(:id), employer)
      end
      if (location = attributes[:location])
        @location = FbGraph::Page.new(location.delete(:id), location)
      end
      if (position = attributes[:position])
        @position = FbGraph::Page.new(position.delete(:id), position)
      end
      if attributes[:start_date]
        @start_date = Date.new(*attributes[:start_date].split('-').collect(&:to_i))
      end
      if attributes[:end_date]
        @end_date = Date.new(*attributes[:end_date].split('-').collect(&:to_i))
      end
    end
  end
end