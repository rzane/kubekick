require "yaml"

module Kubekick
  class Kubectl
    class Secret
      def initialize(data : String)
        @data = YAML.parse(data)
      end

      def value_of(key : String)
        @data["data"][key].as_s
      end
    end
  end
end
