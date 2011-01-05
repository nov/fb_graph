module FbGraph
  class Project < Page
    attr_accessor :start_date, :end_date

    def initialize(identifier, attributes = {})
      super
      if attributes[:start_date]
        year, month = attributes[:start_date].split('-').collect(&:to_i)
        @start_date = if month == 0
          Date.new(year)
        else
          Date.new(year, month)
        end
      end
      if attributes[:end_date]
        year, month = attributes[:end_date].split('-').collect(&:to_i)
        @end_date = if month == 0
          Date.new(year)
        else
          Date.new(year, month)
        end
      end
    end
  end
end