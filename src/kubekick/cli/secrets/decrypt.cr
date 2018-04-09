require "./helpers"
require "../helpers"
require "../../kubectl"

module Kubekick
  class CLI
    module Secrets
      class Decrypt
        include CLI::Helpers
        include CLI::Secrets::Helpers

        getter! filename : String
        getter! kubectl : Kubectl
        getter! replace : Bool

        def initialize(@filename, @kubectl, @replace)
        end

        def run
          ejson = read_template(filename)
          public_key = EJSON.public_key(ejson)
          secret_key = retrieve_secret_key(public_key)
          secret_file = SecretFile.decrypt(ejson, secret_key)
          output_secrets(secret_file.to_pretty_json)
        end
      end
    end
  end
end
