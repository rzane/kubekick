require "yaml"
require "uuid"

module Kubekick
  struct Definition
    getter! uuid : String

    def initialize(content : String)
      @definition = YAML.parse(content)
      @uuid = UUID.random.to_s
    end

    def name
      %(#{@definition["metadata"]["name"].as_s}-#{@uuid})
    end

    def dump
      meta = @definition["metadata"].as_h
      meta = meta.merge({"name" => name})

      data = @definition.as_h
      data = data.merge({"metadata" => meta})

      YAML.dump(data)
    end
  end
end
