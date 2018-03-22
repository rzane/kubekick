require "./definition"
require "./kubectl"

module Kubekick
  struct CLI
    def run
      definition = Definition.new(ARGF.gets_to_end)

      kubectl = Kubectl.new
      kubectl.create_pod(definition.dump)

      loop do
        pod = kubectl.get_pod(definition.name)

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

        sleep 1
      end
    end
  end
end

Kubekick::CLI.new.run
