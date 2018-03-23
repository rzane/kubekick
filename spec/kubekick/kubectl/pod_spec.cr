require "minitest/autorun"
require "../../../src/kubekick/kubectl/pod"

describe Kubekick::Kubectl::Pod do
  include Kubekick

  let :json do
    <<-JSON
    {
      "metadata": {
        "name": "foo"
      },
      "status": {
        "phase": "Pending"
      }
    }
    JSON
  end

  let :pod do
    Kubectl::Pod.new(json)
  end

  it "has a name" do
    pod.name.must_equal "foo"
  end

  it "has a phase" do
    pod.phase.must_equal Kubectl::Pod::Phase::Pending
  end
end
