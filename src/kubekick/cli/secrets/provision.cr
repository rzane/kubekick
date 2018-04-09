require "cox"
require "./helpers"
require "../helpers"
require "../../kubectl"

module Kubekick
  class CLI
    module Secrets
      class Provision
        include CLI::Helpers
        include CLI::Secrets::Helpers

        getter! kubectl : Kubectl

        def initialize(@kubectl)
        end

        def run
          keypair = Cox::KeyPair.new
          public_key = Base64.strict_encode(keypair.public.bytes)
          secret_key = Base64.strict_encode(keypair.secret.bytes)

          say kubectl.create_secret(
            name: SECRET_NAME,
            key: public_key,
            value: secret_key
          )

          say ""
          say "Public key:     #{public_key}"
          say "Private key:    #{secret_key}"
        end
      end
    end
  end
end
