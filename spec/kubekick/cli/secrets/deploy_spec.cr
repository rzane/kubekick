require "../../../spec_helper"

describe Kubekick::CLI::Secrets::Deploy do
  include Kubekick

  let :filename do
    fixture_file("secrets.ejson").as String
  end

  let :kubectl do
    FakeKubectl.new
  end

  let :cli do
    CLI::Secrets::Deploy.new(filename: filename, kubectl: kubectl)
  end

  let :secret do
    data = <<-EOYAML
    data:
      #{PUBLIC_KEY}: #{Base64.strict_encode(PRIVATE_KEY)}
    EOYAML

    Kubectl::Secret.new(data)
  end

  before do
    cli.output = IO::Memory.new
  end

  it "synchronizes secrets" do
    kubectl._secret = secret
    cli.run

    data = <<-EODATA
    ---
    kind: Secret
    apiVersion: v1
    type: Opaque
    metadata:
      name: secrets
      labels:
        name: secrets
    data:
      kubekick: Zm9vYmFy
      not-encrypted: Y3JhY2tlcnM=

    EODATA

    kubectl._applied.must_equal({"secrets" => data})
  end

  it "fails when ejson-keys secret does not exist" do
    kubectl._exists = false

    error = assert_raises Kubekick::CLI::SecretError do
      cli.run
    end

    error.message.must_match(/secret 'ejson-keys' does not exist/)
  end

  it "fails when private key is missing" do
    error = assert_raises Kubekick::CLI::SecretError do
      cli.run
    end

    error.message.must_match(/expected to find a value for/)
  end

  class FakeKubectl < Kubekick::Kubectl
    property _exists : Bool = true
    property _secret : Kubectl::Secret = Kubectl::Secret.new(%({"data": {}}))
    property _applied : Hash(String, String) = {} of String => String

    def get_secrets(_name)
      _secret
    end

    def secret_exists?(_name)
      _exists
    end

    def apply(name, data)
      _applied[name] = data
      ""
    end
  end
end
