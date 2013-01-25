require 'base64'
require 'openssl'

module FbGraph
  class Auth
    class SignedRequest
      OAUTH_DIALOG_ENDPOINT = 'https://www.facebook.com/dialog/oauth'

      def self.verify(client, signed_request)
        signature, payload = signed_request.split('.')
        raise VerificationFailed.new('No Signature') if signature.blank?
        raise VerificationFailed.new('No Payload') if payload.blank?
        signature = base64_url_decode signature
        data = decode_json base64_url_decode(payload)
        raise VerificationFailed.new('Unexpected Signature Algorithm') unless data[:algorithm] == 'HMAC-SHA256'
        _signature_ = sign(client.secret, payload)
        raise VerificationFailed.new('Signature Invalid') unless signature == _signature_
        data
      end

      private

      def self.sign(key, payload)
        klass = OpenSSL::Digest::SHA256.new
        OpenSSL::HMAC.digest(klass, key, payload)
      end

      def self.decode_json(json)
        MultiJson.load(json).with_indifferent_access
      rescue => e
        raise VerificationFailed.new('Invalid JSON')
      end

      def self.base64_url_decode(str)
        str += '=' * (4 - str.length.modulo(4))
        str = str.gsub('-', '+').gsub('_', '/')
        Base64.decode64 str
      end
    end
  end
end
