require 'digest/md5'

module FbGraph
  class Auth
    class Cookie
      # NOTE:
      # If you want access token, use FbGraph::Auth.new(APP_ID, APP_SECRET, :cookie => {..}) instead
      def self.parse(client, cookie)
        fb_cookie_string = if cookie.is_a?(Hash)
          cookie["fbs_#{client.id}"]
        else
          cookie
        end

        raise VerificationFailed.new(401, 'Facebook cookie not found') if fb_cookie_string.blank?

        fb_cookie_string.gsub!(/[\\"]/, '')
        signature, fb_cookie = '', {}
        fb_cookie_string.split('&').each do |kv|
          k, v = kv.split('=')
          if k == 'sig'
            signature = v
          else
            v = v.to_i if ['uid', 'expires'].include?(k)
            fb_cookie[k] = v
          end
        end

        signature_base_string = fb_cookie.to_a.sort do |a, b|
          a[0] <=> b[0] || a[1] <=> b[1]
        end.map do |(k, v)|
          "#{k}=#{v}"
        end.join

        unless Digest::MD5.hexdigest("#{signature_base_string}#{client.secret}") == signature
          raise VerificationFailed.new(401, 'Facebook cookie signature invalid')
        end

        fb_cookie.with_indifferent_access
      end
    end
  end
end