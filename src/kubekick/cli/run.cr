require "../kubectl"
require "./helpers"

module Kubekick
  class CLI
    class Run
      include Helpers

      getter! kubectl : Kubectl
      getter! filename : String

      def initialize(@filename, @kubectl)
      end

      def run
        template = read_template(filename)
        definition = Kubectl::Definition.new(template)
        kubectl.create(definition.name, definition.dump)

        loop do
          pod = kubectl.get_pod(definition.name)
          print_pod_status(pod)
          sleep 3
        end
      rescue err : Kubectl::Error
        abort err.message
      end

      private def print_pod_status(pod)
        case pod.phase
        when .pending?
          say %(pod "#{pod.name}" pending)
        when .running?
          say %(pod "#{pod.name}" running)
        when .succeeded?
          say %(pod "#{pod.name}" succeeded)
          kubectl.delete_pod(pod.name)
          say %(pod "#{pod.name}" deleted)
          exit 0
        when .failed?
          say %(pod "#{pod.name}" failed)
          exit 1
        when .unknown?
          say %(pod "#{pod.name}" unknown)
          exit 1
        end
      end
    end
  end
end
