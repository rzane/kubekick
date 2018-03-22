require "json"
require "./crypto"

module Kubekick
  module EJSON
    class StructureError < Exception
    end

    def self.decrypt(data, secret)
      encrypted = JSON.parse_raw(data)
      decrypted = walk(encrypted, secret)
      JSON::Any.new(decrypted)
    end

    def self.public_key(data)
      encrypted = JSON.parse(data)
      encrypted["_public_key"].as_s
    end

    def self.walk(data : Hash(String, JSON::Type), secret)
      result = {} of String => JSON::Type

      data.each do |key, value|
        if value.is_a?(String) && !key.starts_with?("_")
          result[key] = Crypto.decrypt(value, secret)
        else
          result[key] = walk(value, secret)
        end
      end

      result
    end

    def self.walk(data : Array(JSON::Type), secret)
      result = [] of JSON::Type

      data.each do |item|
        result << walk(item, secret)
      end

      result
    end

    def self.walk(data, _secret)
      data
    end
  end
end
