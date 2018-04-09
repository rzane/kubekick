require "./helpers"
require "../helpers"
require "../../kubectl"
require "../../secret_file"

module Kubekick
  class CLI
    module Secrets
      class Deploy
        include CLI::Helpers
        include CLI::Secrets::Helpers

        getter! kubectl : Kubectl
        getter! filename : String

        def initialize(@filename, @kubectl)
        end

        def run
          ejson = read_template(filename)
          public_key = EJSON.public_key(ejson)
          secret_key = retrieve_secret_key(public_key)
          secret_file = SecretFile.decrypt(ejson, secret_key)

          secret_file.secrets.each do |name|
            say kubectl.apply(name, secret_file.yaml_for(name))
          end
        rescue err : Kubectl::Error
          abort err.message
        end

        private def secrets_exist?(name)
          kubectl.get_secrets(name)
          true
        rescue Kubectl::Error
          false
        end

        private def load_ejson_secret(ejson)
          public_key = EJSON.public_key(ejson)
          secrets = kubectl.get_secrets(SECRET_NAME)
          secrets.value_of(public_key)
        end
      end
    end
  end
end
