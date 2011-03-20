module FbGraph
  class Education
    include Comparison

    attr_accessor :school, :degree, :year, :concentration, :classes, :type

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
      @classes = []
      if attributes[:classes]
        attributes[:classes].each do |klass|
          @classes << Klass.new(klass.delete(:id), klass)
        end
      end
      @type = attributes[:type]
    end
  end
end