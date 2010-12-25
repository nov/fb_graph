module FbGraph
  class Education
    include Comparison

    attr_accessor :school, :degree, :year, :concentration

    def initialize(attributes = {})
      if (school = attributes[:school])
        @school = Page.new(school.delete(:id), school)
      end
      if (degree = attributes[:degree])
        @degree = Page.new(degree.delete(:id), degree)
      end
      if (year = attributes[:year])
        @year = Page.new(year.delete(:id), year)
      end
      @concentration = []
      if attributes[:concentration]
        attributes[:concentration].each do |concentration|
          @concentration << Page.new(concentration.delete(:id), concentration)
        end
      end
    end
  end
end