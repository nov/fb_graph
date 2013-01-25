module FbGraph
  class Targeting
    include Comparison

    attr_accessor :country, :city, :region, :locale

    def initialize(attributes = {})
      @country = attributes[:country]
      @city    = attributes[:city]
      @region  = attributes[:region]
      @locale  = attributes[:locale]
    end

    def to_hash(options = {})
      {
        :country => self.country,
        :city    => self.city,
        :region  => self.region,
        :locale  => self.locale
      }
    end
  end
end