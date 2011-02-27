module FbGraph
  class Auth
    class SignedRequest
      def self.verify(client, signed_request)
        signature, payload = signed_request.split('.')
        data = JSON.parse(Base64.decode64(payload)).with_indifferent_access
        raise VerificationFailed.new('Unexpected Signature Algorithm') unless data[:algorithm] == 'HMAC-SHA256'
        _signature_ = HMAC::SHA256.digest(client.secret, payload)
        raise VerificationFailed.new('Singature Invalid') unless signature == _signature_
        data
      end

      private

      def self.base64_url_decode(str)
        str += '=' * (4 - str.length.modulo(4))
        str = str.gsub('-', '+').gsub('_', '/')
        Base64.decode64 str
      end
    end
  end
end
