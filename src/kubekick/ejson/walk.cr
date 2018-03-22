module Kubekick
  module EJSON
    module Walk
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
end
