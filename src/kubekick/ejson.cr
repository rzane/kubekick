require "json"
require "./ejson/crypto"
require "./ejson/walk"

module Kubekick
  module EJSON
    class StructureError < Exception
    end

    def self.encrypt(data, public_key, secret_key)
      decrypted = JSON.parse_raw(data)

      encrypted = Walk.walk(decrypted) do |value|
        if Crypto.encrypted?(value)
          value
        else
          Crypto.encrypt(value, public_key, secret_key)
        end
      end

      JSON::Any.new(encrypted)
    end

    def self.decrypt(data, secret_key)
      encrypted = JSON.parse_raw(data)

      decrypted = Walk.walk(encrypted) do |value|
        if Crypto.encrypted?(value)
          Crypto.decrypt(value, secret_key)
        else
          value
        end
      end

      JSON::Any.new(decrypted)
    end

    def self.public_key(data)
      encrypted = JSON.parse(data)
      key = encrypted["_public_key"].as_s
    end
  end
end
