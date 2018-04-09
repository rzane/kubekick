require "../../spec_helper"

describe Kubekick::CLI::Run do
  include Kubekick

  let :filename do
    fixture_file("task.yaml").as String
  end

  let :kubectl do
    FakeKubectl.new
  end

  let :cli do
    CLI::Run.new(filename: filename, kubectl: kubectl)
  end

  before do
    cli.output = IO::Memory.new
    cli.delay_duration = 0
  end

  it "runs a successful pod" do
    kubectl._pod_phases = ["Pending", "Running", "Succeeded"]
    cli.run

    lines = cli.output.to_s.split("\n")
    lines.shift.must_match(/pod "example-.*" pending/)
    lines.shift.must_match(/pod "example-.*" running/)
    lines.shift.must_match(/pod "example-.*" succeeded/)
    lines.shift.must_match(/pod "example-.*" deleted/)

    kubectl._pod_created.must_match(/example-.*/)
    kubectl._pod_deleted.must_match(/example-.*/)
    kubectl._pod_created.must_equal(kubectl._pod_deleted)
  end

  it "runs a failed pod" do
    kubectl._pod_phases = ["Pending", "Running", "Failed"]

    assert_raises CLI::Run::Error do
      cli.run
    end

    lines = cli.output.to_s.split("\n")
    lines.shift.must_match(/pod "example-.*" pending/)
    lines.shift.must_match(/pod "example-.*" running/)
    lines.shift.must_match(/pod "example-.*" failed/)

    kubectl._pod_created.must_match(/example-.*/)
    kubectl._pod_deleted.must_be_nil
  end

  it "runs an unknown pod" do
    kubectl._pod_phases = ["Pending", "Running", "Unknown"]

    assert_raises CLI::Run::Error do
      cli.run
    end

    lines = cli.output.to_s.split("\n")
    lines.shift.must_match(/pod "example-.*" pending/)
    lines.shift.must_match(/pod "example-.*" running/)
    lines.shift.must_match(/pod "example-.*" unknown/)

    kubectl._pod_created.must_match(/example-.*/)
    kubectl._pod_deleted.must_be_nil
  end

  class FakeKubectl < Kubekick::Kubectl
    property _pod_phases : Array(String) = [] of String
    property _pod_created : String?
    property _pod_deleted : String?

    def create(name, template)
      self._pod_created = name
    end

    def get_pod(name)
      Pod.new(%({"metadata": {"name": "#{name}"}, "status": {"phase": "#{_pod_phases.shift}"}}))
    end

    def delete_pod(name)
      self._pod_deleted = name
    end
  end
end
