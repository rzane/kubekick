require "../secret_file"
require "../kubectl"

module Kubekick
  class CLI
    class Secrets
      SECRET_NAME = "ejson-keys"

      getter! kubectl : Kubectl
      getter! filename : String

      def initialize(@filename, @kubectl)
      end

      def run
        ejson = read_ejson_file()
        secret_key = load_ejson_secret(ejson)
        secret_file = SecretFile.decrypt(ejson, secret_key)

        secret_file.secrets.each do |name|
          puts kubectl.apply(name, secret_file.yaml_for(name))
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

      private def read_ejson_file
        if filename == "-"
          STDIN.gets_to_end
        else
          File.read(filename)
        end
      end
    end
  end
end
