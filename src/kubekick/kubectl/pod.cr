require "yaml"

module Kubekick
  class Kubectl
    class Pod
      enum Phase
        Pending
        Running
        Succeeded
        Failed
        Unknown
      end

      def initialize(data : String)
        @data = YAML.parse(data)
      end

      def name
        @data["metadata"]["name"].as_s
      end

      def phase
        Phase.parse @data["status"]["phase"].as_s
      end
    end
  end
end
