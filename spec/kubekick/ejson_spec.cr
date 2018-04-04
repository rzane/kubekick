require "../spec_helper"

describe Kubekick::EJSON do
  include Kubekick

  let :public do
    "870c8b7867009b93652549c4144cd425bd03043a36e207cce13411d260385732"
  end

  let :secret do
    "1d59c0892d42cd5959dd6b8e8b04f1a0061a4c4901e075bad291c109aeac1688"
  end

  let :box do
    EJSON::Crypto.encrypt("foobar", public, secret)
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
    result = EJSON.decrypt(shallow, secret)
    result["example"].as_s.must_equal("foobar")
  end

  it "can decrypt deep properties" do
    result = EJSON.decrypt(deep, secret)
    result["deep"][0]["example"].as_s.must_equal("foobar")
  end

  it "can decrypt arrays" do
    result = EJSON.decrypt(array, secret)
    result[0]["example"].as_s.must_equal("foobar")
  end

  it "ignores underscores" do
    result = EJSON.decrypt(ignored, secret)
    result["_example"].as_s.must_equal(box)
  end
end
