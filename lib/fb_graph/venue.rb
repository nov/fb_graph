module FbGraph
  class Venue
    include FbGraph::Comparison

    attr_accessor :street, :city, :state, :zip, :country, :latitude, :longitude

    def initialize(attriutes = {})
      @street    = attriutes[:street]
      @city      = attriutes[:city]
      @state     = attriutes[:state]
      @zip       = attriutes[:zip]
      @country   = attriutes[:country]
      @latitude  = attriutes[:latitude]
      @longitude = attriutes[:longitude]
    end
  end
end