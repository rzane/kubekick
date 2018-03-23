require "yaml"
require "crustache"
require "./helpers"

module Kubekick
  class CLI
    class Template
      include Helpers

      getter! filename : String
      getter! parameters : Array(String)
      getter! from : Array(String)

      def initialize(@filename, @parameters, @from)
      end

      def run
        values = {} of String => String

        from.each do |file|
          YAML.parse(File.read(file)).each do |key, value|
            values[key.as_s] = value.as_s
          end
        end

        parameters.each do |parameter|
          key, value = parameter.split("=", 2)
          values[key] = value
        end

        template = read_template(filename)
        template = Crustache.parse(template)
        say Crustache.render(template, values)
      end
    end
  end
end
