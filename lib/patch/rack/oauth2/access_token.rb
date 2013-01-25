module Rack
  module OAuth2
    class AccessToken
      def initialize_with_expires_support(attributes = {})
        initialize_without_expires_support attributes
        self.expires_in ||= attributes[:expires]
      end
      alias_method_chain :initialize, :expires_support
    end
  end
end