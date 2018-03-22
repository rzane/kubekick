require "../ejson"
require "../kubectl"

module Kubekick
  class CLI
    class Run
      getter! kubectl : Kubectl
      getter! filename : String

      def initialize(@filename, @kubectl)
      end

      def run
        public_key = EJSON.public_key(read_secrets)
        private_key = @kubectl.get_secret(public_key)
      end

      private def read_secrets
        if filename == "-"
          ARGF.gets_to_end
        else
          File.read(filename)
        end
      end
    end
  end
end
