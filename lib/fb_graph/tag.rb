module FbGraph
  class Tag
    include FbGraph::Comparison

    attr_accessor :user, :x, :y, :created_time

    def initialize(identifier, options = {})
      @x = options.delete(:x)
      @y = options.delete(:y)
      if (created_time = options.delete(:created_time))
        @created_time = Time.parse(created_time)
      end
      @user = User.new(identifier, options)
    end
  end
end