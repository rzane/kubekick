module Kubekick
  module EJSON
    module Walk
      alias Transform = String -> String

      def self.walk(data : Hash(String, JSON::Type), &transform : Transform)
        result = {} of String => JSON::Type

        data.each do |key, value|
          if value.is_a?(String) && !key.starts_with?("_")
            result[key] = yield(value)
          else
            result[key] = walk(value, &transform)
          end
        end

        result
      end

      def self.walk(data : Array(JSON::Type), &transform)
        result = [] of JSON::Type

        data.each do |item|
          result << walk(item, &transform)
        end

        result
      end

      def self.walk(data, &transform)
        data
      end
    end
  end
end
