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
          public_key = keypair.public.bytes.hexstring
          secret_key = keypair.secret.bytes.hexstring

          say kubectl.create_secret(
            name: SECRET_NAME,
            key: public_key,
            value: secret_key
          )

          say "public key:  #{public_key}"
          say "secret key:  #{secret_key}"
        end
      end
    end
  end
end
