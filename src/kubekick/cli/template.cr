require "../kubectl"

module Kubekick
  class CLI
    class Template
      getter! filename : String

      def initialize(@filename)
      end

      def run
      end
    end
  end
end
