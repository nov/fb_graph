module FbGraph
  class Tag
    include Comparison

    attr_accessor :user, :name, :x, :y, :created_time

    def initialize(attributes = {})
      @x = attributes.delete(:x)
      @y = attributes.delete(:y)
      if (created_time = attributes.delete(:created_time))
        @created_time = Time.parse(created_time).utc
      end
      if (identifier = attributes.delete(:id)).present?
        @user = User.new(identifier, attributes)
      end
      @name = attributes[:name]
    end
  end
end