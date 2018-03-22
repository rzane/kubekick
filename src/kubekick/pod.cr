require "yaml"

module Kubekick
  struct Pod
    enum Phase
      Pending
      Running
      Succeeded
      Failed
      Unknown
    end

    def self.from_yaml(value)
      data = YAML.parse(value)
      name = data["metadata"]["name"].as_s
      phase = data["status"]["phase"].as_s
      new(name: name, phase: Phase.parse(phase))
    end

    getter! name : String
    getter! phase : Phase

    def initialize(@name, @phase)
    end
  end
end
