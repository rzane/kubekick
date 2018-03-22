require "json"
require "./ejson/crypto"
require "./ejson/walk"

module Kubekick
  module EJSON
    class StructureError < Exception
    end

    def self.decrypt(data, secret)
      encrypted = JSON.parse_raw(data)
      decrypted = Walk.walk(encrypted, secret)
      JSON::Any.new(decrypted)
    end

    def self.public_key(data)
      encrypted = JSON.parse(data)
      encrypted["_public_key"].as_s
    end
  end
end
