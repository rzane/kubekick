require "../helpers"
require "../../kubectl"
require "../../ejson"

module Kubekick
  class CLI
    module Secrets
      class Decrypt
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
          decrypted = EJSON.decrypt(ejson, secret_key)
          output_secrets(decrypted.to_pretty_json)
        end
      end
    end
  end
end
