module FbGraph
  class Education
    include Comparison

    attr_accessor :school, :degree, :year, :concentration, :classes, :type

    def initialize(attributes = {})
      if (school = attributes[:school])
        @school = Page.new(school[:id], school)
      end
      if (degree = attributes[:degree])
        @degree = Page.new(degree[:id], degree)
      end
      if (year = attributes[:year])
        @year = Page.new(year[:id], year)
      end
      @concentration = []
      if attributes[:concentration]
        attributes[:concentration].each do |concentration|
          @concentration << Page.new(concentration[:id], concentration)
        end
      end
      @classes = []
      if attributes[:classes]
        attributes[:classes].each do |klass|
          @classes << Klass.new(klass[:id], klass)
        end
      end
      @type = attributes[:type]
    end
  end
end