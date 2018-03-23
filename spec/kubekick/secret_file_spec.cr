require "minitest/autorun"
require "../../../src/kubekick/secret_file"

describe Kubekick::SecretFile do
  include Kubekick

  let :private_key do
    File.read_lines("examples/secrets/private.key").last.strip.as(String)
  end

  let :data do
    File.read("examples/secrets/secrets.ejson")
  end

  let :file do
    SecretFile.decrypt(data, private_key)
  end

  it "generates a secret" do
    file.secrets.must_equal ["secrets"]
  end

  it "generates yaml" do
    file.yaml_for("secrets").must_equal <<-YAML
    ---
    kind: Secret
    apiVersion: v1
    type: Opaque
    metadata:
      name: secrets
      labels:
        name: secrets
    data:
      kubekick: #{Base64.strict_encode("foobar")}
      not-encrypted: #{Base64.strict_encode("crackers")}

    YAML
  end
end
