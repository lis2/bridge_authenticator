require 'gpgme'
require 'faraday'
require 'base64'

module Appvault
  module FaradayMiddleware
    class Auth < Faraday::Middleware
      attr_reader :key_id

      def initialize(app, key_id)
        @key_id = key_id
        super(app)
      end

      def call(env)
        env[:request_headers]["X-Api-Timestamp"] = Time.now.to_f.to_s
        env[:request_headers]["X-Api-Key-Id"] = @key_id
        env[:request_headers]["X-Api-Signature"] = signed_api_fingerprint(env[:request_headers], env, @key_id)
        @app.call env
      end

      def signed_api_fingerprint(headers, env, key_id)
        crypto = GPGME::Crypto.new
        signature = crypto.detach_sign(api_fingerprint(headers, env), :armor => true, :signer => key_id)
        Base64.encode64(signature.to_s).gsub(/\n/, "")
      end

      def api_fingerprint(headers, env)
        [
          headers["X-Api-Timestamp"], env["body"].to_s
        ].join("\n")
      end
    end
  end
end
