require "yaml"
require "crustache"

module Kubekick
  class CLI
    class Template
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
          key, value = parameter.split(":", 2)
          values[key] = value
        end

        template = Crustache.parse(read_file)
        puts Crustache.render(template, values)
      end

      private def read_file
        if filename == "-"
          STDIN.gets_to_end
        else
          File.read(filename)
        end
      end
    end
  end
end
