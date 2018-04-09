require "../helpers"
require "../../kubectl"
require "../../ejson"
require "../../secret_file"

module Kubekick
  class CLI
    module Secrets
      class Deploy
        include Helpers

        getter! kubectl : Kubectl
        getter! filename : String

        def initialize(@filename, @kubectl)
        end

        def run
          assert_secret_exists!

          ejson = read_template(filename)
          public_key = EJSON.public_key(ejson)
          secret_key = retrieve_secret_key(public_key)
          decrypted = EJSON.decrypt(ejson, secret_key)
          secret_file = SecretFile.new(decrypted)

          secret_file.secrets.each do |name|
            say kubectl.apply(name, secret_file.yaml_for(name))
          end
        end
      end
    end
  end
end
