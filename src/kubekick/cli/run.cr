require "../kubectl"

module Kubekick
  class CLI
    class Run
      getter! kubectl : Kubectl
      getter! filename : String

      def initialize(@filename, @kubectl)
      end

      def run
        definition = Kubectl::Definition.new(read_template)
        kubectl.create(definition.dump)

        loop do
          pod = kubectl.get_pod(definition.name)
          print_pod_status(pod)
          sleep 1
        end
      end

      private def print_pod_status(pod)
        case pod.phase
        when .pending?
          puts %(pod "#{pod.name}" pending)
        when .running?
          puts %(pod "#{pod.name}" running)
        when .succeeded?
          puts %(pod "#{pod.name}" succeeded)
          kubectl.delete_pod(pod.name)
          puts %(pod "#{pod.name}" deleted)
          exit 0
        when .failed?
          puts %(pod "#{pod.name}" failed)
          exit 1
        when .unknown?
          puts %(pod "#{pod.name}" unknown)
          exit 1
        end
      end

      private def read_template
        if filename == "-"
          ARGF.gets_to_end
        else
          File.read(filename)
        end
      end
    end
  end
end
