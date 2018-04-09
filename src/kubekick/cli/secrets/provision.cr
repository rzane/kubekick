require "cox"
require "../helpers"
require "../../kubectl"

module Kubekick
  class CLI
    module Secrets
      class Provision
        include Helpers

        getter! kubectl : Kubectl

        def initialize(@kubectl)
        end

        def run
          refute_secret_exists!

          keypair = Cox::KeyPair.new
          public_key = Base64.strict_encode(keypair.public.bytes)
          secret_key = Base64.strict_encode(keypair.secret.bytes)

          kubectl.create_secret(
            name: SECRET_NAME,
            key: public_key,
            value: secret_key
          )

          say "created '#{SECRET_NAME}'"
          say "public key:  #{public_key}"
          say "secret key:  #{secret_key}"
        end
      end
    end
  end
end
