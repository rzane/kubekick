require "base64"
require "../ejson"
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
        secret = load_ejson_secret(ejson)
        puts EJSON.decrypt(ejson, secret)
      end

      private def load_ejson_secret(ejson)
        public_key = EJSON.public_key(ejson)
        secrets = kubectl.get_secrets(SECRET_NAME)
        encoded = secrets.value_of(public_key)
        Base64.decode_string(encoded)
      end

      private def read_ejson_file
        if filename == "-"
          ARGF.gets_to_end
        else
          File.read(filename)
        end
      end
    end
  end
end
