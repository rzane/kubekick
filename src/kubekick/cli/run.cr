require "../kubectl"
require "./helpers"

module Kubekick
  class CLI
    class Run
      class Error < Exception
      end

      include Helpers

      getter! kubectl : Kubectl
      getter! filename : String

      property delay_duration : Int32 = 3

      def initialize(@filename, @kubectl)
      end

      def run
        template = read_template(filename)
        definition = Kubectl::Definition.new(template)
        kubectl.create(definition.name, definition.dump)

        loop do
          pod = kubectl.get_pod(definition.name)
          say %(pod "#{pod.name}" #{pod.phase.to_s.downcase})

          case pod.phase
          when .succeeded?
            kubectl.delete_pod(pod.name)
            say %(pod "#{pod.name}" deleted)
            break
          when .failed?, .unknown?
            raise Error.new("aborting")
          end

          sleep delay_duration
        end
      end
    end
  end
end
