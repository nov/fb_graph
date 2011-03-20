module FbGraph
  class Work
    include Comparison

    attr_accessor :description, :employer, :location, :position, :projects, :with, :start_date, :end_date

    def initialize(attributes = {})
      @description = attributes[:description]
      if (employer = attributes[:employer])
        @employer = Page.new(employer.delete(:id), employer)
      end
      if (location = attributes[:location])
        @location = Page.new(location.delete(:id), location)
      end
      if (position = attributes[:position])
        @position = Page.new(position.delete(:id), position)
      end
      @projects = []
      if attributes[:projects]
        attributes[:projects].each do |project|
          @projects << Project.new(project.delete(:id), project)
        end
      end
      @with = []
      if attributes[:with]
        attributes[:with].each do |user|
          @with << User.new(user.delete(:id), user)
        end
      end
      if attributes[:start_date] && attributes[:start_date] != '0000-00'
        year, month = attributes[:start_date].split('-').collect(&:to_i)
        @start_date = if month.blank? || month == 0
          Date.new(year)
        else
          Date.new(year, month)
        end
      end
      if attributes[:end_date] && attributes[:end_date] != '0000-00'
        year, month = attributes[:end_date].split('-').collect(&:to_i)
        @end_date = if month.blank? || month == 0
          Date.new(year)
        else
          Date.new(year, month)
        end
      end
    end
  end
end