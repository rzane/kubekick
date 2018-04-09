require "../spec_helper"

describe Kubekick::EJSON do
  include Kubekick

  let :box do
    EJSON::Crypto.encrypt("foobar", PUBLIC_KEY, PRIVATE_KEY)
  end

  let :shallow do
    %({"example": "#{box}"})
  end

  let :deep do
    %({"deep": [{"example": "#{box}"}]})
  end

  let :array do
    %([{"example": "#{box}"}])
  end

  let :ignored do
    %({"_example": "#{box}"})
  end

  it "can decrypt shallow properties" do
    result = EJSON.decrypt(shallow, PRIVATE_KEY)
    result["example"].as_s.must_equal("foobar")
  end

  it "can decrypt deep properties" do
    result = EJSON.decrypt(deep, PRIVATE_KEY)
    result["deep"][0]["example"].as_s.must_equal("foobar")
  end

  it "can decrypt arrays" do
    result = EJSON.decrypt(array, PRIVATE_KEY)
    result[0]["example"].as_s.must_equal("foobar")
  end

  it "ignores underscores" do
    result = EJSON.decrypt(ignored, PRIVATE_KEY)
    result["_example"].as_s.must_equal(box)
  end

  it "gets the public key" do
    EJSON.public_key(%({"_public_key": "123"})).must_equal "123"
  end

  it "raises when public key is missing" do
    error = assert_raises EJSON::PublicKeyError do
      EJSON.public_key(%({}))
    end

    error.message.must_match(/EJSON files must have a key '_public_key' at the top level./)
  end
end
