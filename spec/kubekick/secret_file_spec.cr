require "../spec_helper"

describe Kubekick::SecretFile do
  include Kubekick

  let :private_key do
    file = fixture_file("secrets/private.key")
    lines = File.read_lines(file)
    lines.last.strip.as(String)
  end

  let :data do
    file = fixture_file("secrets/secrets.ejson")
    contents = File.read(file)
    EJSON.decrypt(contents, private_key)
  end

  let :file do
    SecretFile.new(data)
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
