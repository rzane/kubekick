require "yaml"
require "base64"

module Kubekick
  class Kubectl
    class Secret
      def initialize(data : String)
        @data = YAML.parse(data)
      end

      def value_of(key : String)
        Base64.decode_string(@data["data"][key].as_s)
      end
    end
  end
end
