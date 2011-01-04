module FbGraph
  class Venue < Location
    attr_accessor :street, :city, :state, :zip, :country

    def initialize(attriutes = {})
      super
      @street  = attriutes[:street]
      @city    = attriutes[:city]
      @state   = attriutes[:state]
      @zip     = attriutes[:zip]
      @country = attriutes[:country]
    end
  end
end