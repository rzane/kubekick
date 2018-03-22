require "minitest/autorun"
require "../../../src/kubekick/ejson/crypto"

describe Kubekick::EJSON::Crypto do
  include Kubekick::EJSON

  let :public do
    "870c8b7867009b93652549c4144cd425bd03043a36e207cce13411d260385732"
  end

  let :secret do
    "1d59c0892d42cd5959dd6b8e8b04f1a0061a4c4901e075bad291c109aeac1688"
  end

  let :box do
    "EJ[1:jKrjUV7kWoVIWvr9MDl3gv5kYzhRh/0xd6uVHkgVCwM=:hnwE/JS+aDQBBEXZWJqMyzqOQmAXLiNh:OyZmkMZMTze+j9vTqYm3RJBfZLtBGQ==]"
  end

  it "can decrypt a box" do
    Crypto.decrypt(box, secret).must_equal("foobar")
  end

  it "can encrypt a box" do
    enc = Crypto.encrypt("hello", public, secret)
    result = Crypto.decrypt(enc, secret)
    result.must_equal("hello")
  end
end
