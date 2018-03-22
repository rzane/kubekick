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

    def self.kind
      "pod"
    end

    def self.from_yaml(value)
      data = YAML.parse(value)
      name = data["metadata"]["name"].as_s
      phase = data["status"]["phase"].as_s
      new(name: name, phase: phase)
    end

    getter! name : String
    getter! phase : Phase

    def initialize(name, phase)
      @name = name
      @phase = Phase.parse(phase)
    end
  end
end
