require 'base64'
require 'openssl'

module FbGraph
  class Auth
    class SignedRequest
      def self.verify(client, signed_request)
        signature, payload = signed_request.split('.')
        raise VerificationFailed.new(401, 'No Signature') if signature.blank?
        raise VerificationFailed.new(401, 'No Payload') if payload.blank?
        signature = base64_url_decode signature
        data = decode_json base64_url_decode(payload)
        raise VerificationFailed.new(401, 'Unexpected Signature Algorithm') unless data[:algorithm] == 'HMAC-SHA256'
        _signature_ = sign(client.secret, payload)
        raise VerificationFailed.new(401, 'Signature Invalid') unless signature == _signature_
        data
      end

      private

      def self.sign(key, data)
        klass = OpenSSL::Digest::SHA256.new
        OpenSSL::HMAC.digest(klass, key, data)
      end

      def self.decode_json(json)
        JSON.parse(json).with_indifferent_access
      rescue => e
        p e
        raise VerificationFailed.new(400, 'Invalid JSON')
      end

      def self.base64_url_decode(str)
        str += '=' * (4 - str.length.modulo(4))
        str = str.gsub('-', '+').gsub('_', '/')
        Base64.decode64 str
      end
    end
  end
end
