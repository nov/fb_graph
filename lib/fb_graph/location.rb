module FbGraph
  class Location
    include Comparison
    include Serialization

    attr_accessor :latitude, :longitude

    def initialize(attributes = {})
      @latitude  = attributes[:latitude]
      @longitude = attributes[:longitude]
    end

    def to_hash(options = {})
      {
        :latitude  => self.latitude,
        :longitude => self.longitude
      }
    end
  end
end
