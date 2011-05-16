module FbGraph
  class Tag
    include Comparison
    include Serialization

    attr_accessor :user, :name, :x, :y, :created_time

    def initialize(attributes = {})
      @x = attributes[:x]
      @y = attributes[:y]
      if attributes[:created_time]
        @created_time = Time.parse(attributes[:created_time]).utc
      end
      if attributes[:id].present?
        @user = User.new(attributes[:id], attributes)
      end
      @name = attributes[:name]
    end

    def to_hash(options = {})
      hash = {
        :tag_text => self.name,
        :x => self.x,
        :y => self.y
      }
      hash[:tag_uid] = self.user.identifier if self.user
      hash
    end
  end
end