module FbGraph
  class Privacy
    include Comparison
    include Serialization

    attr_accessor :value, :friends, :networks, :allow, :deny

    def initialize(attributes = {})
      @value       = attributes[:value]
      @description = attributes[:description]
      @friends     = attributes[:friends]
      @networks    = attributes[:networks]
      @allow       = attributes[:allow]
      @deny        = attributes[:deny]
    end

    def to_hash(options = {})
      {
        :value => self.value,
        :friends => self.friends,
        :networks => self.networks,
        :allow => self.allow,
        :deny => self.deny
      }
    end
  end
end