require "./definition"
require "./kubectl"
require "./pod"

module Kubekick
  struct CLI
    def run
      definition = Definition.new(ARGF.gets_to_end)

      kubectl = Kubectl.new
      kubectl.create(definition.dump)

      loop do
        pod = kubectl.get(Pod, definition.name)

        case pod.phase
        when .pending?
          puts %(pod "#{pod.name}" pending)
        when .running?
          puts %(pod "#{pod.name}" running)
        when .succeeded?
          puts %(pod "#{pod.name}" succeeded)
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
