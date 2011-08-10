# NOTE: Authorization code given via FB JS SDK needs blank string as redirect_uri
module Rack::OAuth2::Util
  def self.compact_hash(hash)
    hash.reject do |key, value|
      case key
      when :redirect_uri
        value.nil?
      else
        value.blank?
      end
    end
  end
end