require "logger"

module Kubekick
  class CLI
    module Helpers
      property output : IO::FileDescriptor = STDOUT

      def say(message)
        output.puts message
      end

      def read_template(filename)
        if filename == "-"
          STDIN.gets_to_end
        else
          File.read(filename)
        end
      end
    end
  end
end
