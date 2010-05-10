module FbGraph
  class Education
    include FbGraph::Comparison

    attr_accessor :school, :degree, :year, :concentration

    def initialize(attributes = {})
      if (school = attributes[:school])
        @school = FbGraph::Page.new(school.delete(:id), school)
      end
      if (degree = attributes[:degree])
        @degree = FbGraph::Page.new(degree.delete(:id), degree)
      end
      if (year = attributes[:year])
        @year = FbGraph::Page.new(year.delete(:id), year)
      end
      @concentration = []
      if attributes[:concentration]
        attributes[:concentration].each do |concentration|
          @concentration << FbGraph::Page.new(concentration.delete(:id), concentration)
        end
      end
    end
  end
end