module FbGraph
  class Targeting
    include Comparison

    attr_accessor :country, :city, :region, :locale

    def initialize(attriutes = {})
      @country = attriutes[:country]
      @city    = attriutes[:city]
      @region  = attriutes[:region]
      @locale  = attriutes[:locale]
    end

    def to_s
      {
        :country => self.country,
        :city => self.city,
        :region => self.region,
        :locale => self.locale
      }.to_json
    end
  end
end