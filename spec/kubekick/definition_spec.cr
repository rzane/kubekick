require "minitest/autorun"
require "../../src/kubekick/definition"

describe Kubekick::Definition do
  include Kubekick

  let :yaml do
    <<-YAML
    metadata:
      name: foo
    status:
      phase: Succeeded
    YAML
  end

  let :definition do
    Definition.new(yaml)
  end

  it "has a uuid" do
    definition.uuid.wont_be_nil
  end

  it "has a name" do
    definition.name.must_equal "foo-#{definition.uuid}"
  end

  it "can dump yaml with an updated name" do
    data = YAML.parse definition.dump
    name = data["metadata"]["name"].as_s
    name.must_equal definition.name
  end
end
