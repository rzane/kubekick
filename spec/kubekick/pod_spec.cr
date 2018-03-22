require "minitest/autorun"
require "../../src/kubekick/pod"

describe Kubekick::Pod do
  include Kubekick

  let :pod do
    Pod.new("foo", Pod::Phase::Pending)
  end

  let :yaml do
    <<-YAML
    metadata:
      name: foo
    status:
      phase: Succeeded
    YAML
  end

  it "has a name" do
    pod.name.must_equal "foo"
  end

  it "has a phase" do
    pod.phase.must_equal Pod::Phase::Pending
  end

  it "parses yaml" do
    pod = Pod.from_yaml(yaml)
    pod.name.must_equal "foo"
    pod.phase.must_equal Pod::Phase::Succeeded
  end
end
