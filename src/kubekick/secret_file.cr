require "yaml"
require "base64"
require "./ejson"

module Kubekick
  class SecretFile
    NAME = "kubernetes_secrets"

    def self.decrypt(data : String, secret_key : String)
      new EJSON.decrypt(data, secret_key)
    end

    def initialize(@data : JSON::Any)
    end

    def secrets
      @data[NAME].as_h.keys
    end

    def data_for(name)
      spec = @data[NAME][name]
      data = {} of String => String

      spec["data"].each do |key, value|
        data[key.as_s.sub(/^_/, "")] = Base64.strict_encode(value.as_s)
      end

      data
    end

    def template_for(name)
      {
        "kind" => "Secret",
        "apiVersion" => "v1",
        "type" => @data[NAME][name]["_type"].as_s,
        "metadata" => { "name" => name, "labels" => { "name" => name } },
        "data" => data_for(name)
      }
    end

    def yaml_for(name)
      YAML.dump template_for(name)
    end
  end
end
