require "../helpers"
require "../../ejson"
require "../../kubectl"

module Kubekick
  class CLI
    module Secrets
      class Encrypt
        include Helpers

        getter! filename : String
        getter! kubectl : Kubectl
        getter! replace : Bool

        def initialize(@filename, @kubectl, @replace)
        end

        def run
          assert_secret_exists!
          
          ejson = read_template(filename)
          public_key = EJSON.public_key(ejson)
          secret_key = retrieve_secret_key(public_key)
          encrypted = EJSON.encrypt(ejson, public_key, secret_key)
          output_secrets(encrypted.to_pretty_json)
        end
      end
    end
  end
end
