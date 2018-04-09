require "../spec_helper"

describe Kubekick::SecretFile do
  include Kubekick

  let :data do
    file = fixture_file("secrets.ejson")
    contents = File.read(file)
    EJSON.decrypt(contents, PRIVATE_KEY)
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
