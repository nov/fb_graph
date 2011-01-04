module FbGraph
  class Location
    include Comparison
    include Serialization

    attr_accessor :latitude, :longitude

    def initialize(attriutes = {})
      @latitude  = attriutes[:latitude]
      @longitude = attriutes[:longitude]
    end

    def to_hash(options = {})
      {
        :latitude  => self.latitude,
        :longitude => self.longitude
      }
    end
  end
end
