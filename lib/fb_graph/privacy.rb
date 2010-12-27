module FbGraph
  class Privacy
    include Comparison

    attr_accessor :value, :friends, :networks, :allow, :deny

    def initialize(attriutes = {})
      @value       = attriutes[:value]
      @description = attriutes[:description]
      @friends     = attriutes[:friends]
      @networks    = attriutes[:networks]
      @allow       = attriutes[:allow]
      @deny        = attriutes[:deny]
    end

    def to_s
      {
        :value => self.value,
        :friends => self.friends,
        :networks => self.networks,
        :allow => self.allow,
        :deny => self.deny
      }.delete_if do |k, v|
        v.blank?
      end.to_json
    end
  end
end