require "yaml"
require "crustache"
require "./helpers"

module Kubekick
  class CLI
    class Template
      include Helpers

      getter! filenames : Array(String)
      getter! parameters : Array(String)
      getter! from : Array(String)

      def initialize(@filenames, @parameters, @from)
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

        render(values)
      end

      def render(values)
        collect_files.each do |file|
          template = read_template(file)
          template = Crustache.parse(template)
          say Crustache.render(template, values)
        end
      end

      def collect_files
        filenames.flat_map do |path|
          if File.directory?(path)
            Dir.glob(File.join(path, "*.{yml,yaml,json}"))
          else
            [path]
          end
        end
      end
    end
  end
end
