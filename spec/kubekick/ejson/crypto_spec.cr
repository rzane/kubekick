require "../../spec_helper"

describe Kubekick::EJSON::Crypto do
  include Kubekick::EJSON
  
  let :box do
    "EJ[1:jKrjUV7kWoVIWvr9MDl3gv5kYzhRh/0xd6uVHkgVCwM=:hnwE/JS+aDQBBEXZWJqMyzqOQmAXLiNh:OyZmkMZMTze+j9vTqYm3RJBfZLtBGQ==]"
  end

  it "can decrypt a box" do
    Crypto.decrypt(box, PRIVATE_KEY).must_equal("foobar")
  end

  it "can encrypt a box" do
    enc = Crypto.encrypt("hello", PUBLIC_KEY, PRIVATE_KEY)
    result = Crypto.decrypt(enc, PRIVATE_KEY)
    result.must_equal("hello")
  end
end
