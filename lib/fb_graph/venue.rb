module FbGraph
  class Venue < Location
    attr_accessor :street, :city, :state, :zip, :country

    def initialize(attributes = {})
      super
      @street  = attributes[:street]
      @city    = attributes[:city]
      @state   = attributes[:state]
      @zip     = attributes[:zip]
      @country = attributes[:country]
    end
  end
end