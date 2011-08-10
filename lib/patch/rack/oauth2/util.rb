# NOTE: Authorization code given via FB JS SDK needs blank string as redirect_uri
module Rack::OAuth2::Util
  class << self
    def compact_hash_with_blank_redirect_uri(hash)
      redirect_uri_exists = hash[:redirect_uri]
      result = compact_hash_without_blank_string_redirect_uri_support hash
      if redirect_uri_exists
        result[:redirect_uri] ||= redirect_uri_exists
      end
      result
    end
    alias_method :compact_hash, :blank_redirect_uri
  end
end