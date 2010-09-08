module FbGraph
  class Tag
    include FbGraph::Comparison

    attr_accessor :user, :x, :y, :created_time

    def initialize(identifier, attributes = {})
      @x = attributes.delete(:x)
      @y = attributes.delete(:y)
      if (created_time = attributes.delete(:created_time))
        @created_time = Time.parse(created_time).utc
      end
      @user = User.new(identifier, attributes)
    end
  end
end