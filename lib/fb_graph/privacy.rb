module FbGraph
  class Privacy
    include Comparison
    include Serialization

    attr_accessor :value, :friends, :networks, :allow, :deny

    def initialize(attriutes = {})
      @value       = attriutes[:value]
      @description = attriutes[:description]
      @friends     = attriutes[:friends]
      @networks    = attriutes[:networks]
      @allow       = attriutes[:allow]
      @deny        = attriutes[:deny]
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