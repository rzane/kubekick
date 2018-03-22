require "json"
require "yaml"
require "uuid"

module Kubekick
  class Kubectl
    class Definition
      getter! uuid : String

      def initialize(data : String)
        @uuid = UUID.random.to_s
        @data = YAML.parse(data)
      end

      def name
        %(#{@data["metadata"]["name"].as_s}-#{@uuid})
      end

      def dump
        meta = @data["metadata"].as_h
        meta = meta.merge({"name" => name})

        data = @data.as_h
        data = data.merge({"metadata" => meta})

        YAML.dump(data)
      end
    end
  end
end
