module FbGraph
  class Offer < Node
    extend Searchable

    ATTRS = [ :from,
              :title,
              :created_time,
              :expiration_time,
              :terms,
              :image_url,
              :coupon_type,
              :claim_limit,
              :redemption_link,
              :redemption_code]

    attr_accessor *ATTRS

    def initialize(identifier, attributes = {})
      super

      @from = Page.new(attributes[:from][:id], attributes[:from]) if attributes[:from]
      @title = attributes[:title]
      @created_time = Time.parse(attributes[:created_time]).utc if attributes[:created_time]
      @expiration_time = Time.parse(attributes[:expiration_time]).utc
      @terms = attributes[:terms] if attributes[:terms]
      @image_url = attributes[:image_url] if attributes[:image_url]
      @coupon_type = attributes[:coupon_type] if attributes[:coupon_type]
      @claim_limit = attributes[:claim_limit] if attributes[:claim_limit]
      @redemption_link = attributes[:redemption_link] if attributes[:redemption_link]
      @redemption_code = attributes[:redemption_code] if attributes[:redemption_code]
    end
  end
end
