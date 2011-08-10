# NOTE: Authorization code given via FB JS SDK needs blank string as redirect_uri
module Rack::OAuth2::Util
  class << self
    def compact_hash_with_blank_redirect_uri(hash)
      original_redirect_uri = hash[:redirect_uri]
      result = compact_hash_without_blank_redirect_uri hash
      if original_redirect_uri
        result[:redirect_uri] ||= original_redirect_uri
      end
      result
    end
    alias_method_chain :compact_hash, :blank_redirect_uri
  end
end