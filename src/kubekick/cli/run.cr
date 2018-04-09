require "../kubectl"
require "./helpers"

module Kubekick
  class CLI
    class Run
      include Helpers

      getter! kubectl : Kubectl
      getter! filename : String

      property delay_duration : Int32 = 3

      def initialize(@filename, @kubectl)
      end

      def run : Int32
        template = read_template(filename)
        definition = Kubectl::Definition.new(template)
        kubectl.create(definition.name, definition.dump)

        loop do
          pod = kubectl.get_pod(definition.name)
          say %(pod "#{pod.name}" #{pod.phase.to_s.downcase})

          case pod.phase
          when .succeeded?
            kubectl.delete_pod(pod.name)
            break 0
          when .failed?, .unknown?
            break 1
          end

          sleep delay_duration
        end
      end
    end
  end
end
