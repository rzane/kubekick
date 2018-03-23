require "clim"
require "./kubectl"
require "./version"

module Kubekick
  class CLI < Clim
    main_command do
      desc "A sidekick for Kubernetes deployments"
      usage "kubekick [command] [arguments]"
      version Kubekick.version_string
      run do |options, _arguments|
        puts options.help
      end

      sub_command "template" do
        desc "Replace template variables"

        usage <<-USAGE
        Replace variables in a file:

              kubekick template -f path/to/file.yaml image=alpine:3.6

            Or, pipe the file to STDIN:

              cat path/to/file.yaml | kubekick template -f - image=alpine:3.6

            You can also specify your values in a config file:

              kubekick template -f path/to/file.json --from values.yaml
        USAGE

        option "-f FILE", "--filename FILE",
          type: String,
          desc: "Template file",
          required: true

        option "--from FILE",
          type: Array(String),
          desc: "Path to a YAML/JSON file containing parameters",
          default: [] of String

        run do |options, arguments|
          cmd = CLI::Template.new(
            filename: options.filename.not_nil!,
            from: options.from,
            parameters: arguments
          )

          cmd.run
        end
      end

      sub_command "run" do
        desc "Run a one-off task in a bare pod"
        usage <<-USAGE
        Run a YAML/JSON file:

              kubekick run -f path/to/file.yaml

            Alternatively, you can pipe the file in:

              cat path/to/file.json | kubekick run -f -
        USAGE

        option "-f FILE", "--filename FILE",
          type: String,
          desc: "Filename to use to create the resource",
          required: true

        option "-n NAMESPACE", "--namespace NAMESPACE",
          type: String,
          desc: "The namespace scope"

        option "--context CONTEXT",
          type: String,
          desc: "The name of the kubeconfig context"

        option "--kubeconfig KUBECONFIG",
          type: String,
          desc: "Path to the kubeconfig file"

        run do |options, arguments|
          cmd = CLI::Run.new(
            filename: options.filename.not_nil!,
            kubectl: Kubectl.new(
              context: options.context,
              namespace: options.namespace,
              kubeconfig: options.kubeconfig
            )
          )

          cmd.run
        end
      end

      sub_command "secrets" do
        desc "Synchronize a secrets file with Kubernetes"
        usage <<-USAGE
        Load a JSON file:

              kubekick secrets -f path/to/file.json

            Alternatively, you can pipe the JSON in:

              cat path/to/secrets.json | kubekick secrets -f -
        USAGE

        option "-f FILE", "--filename FILE",
          type: String,
          desc: "Filename containing secrets",
          required: true

        option "-n NAMESPACE", "--namespace NAMESPACE",
          type: String,
          desc: "The namespace scope"

        option "--context CONTEXT",
          type: String,
          desc: "The name of the kubeconfig context"

        option "--kubeconfig KUBECONFIG",
          type: String,
          desc: "Path to the kubeconfig file"

        run do |options, arguments|
          cmd = CLI::Secrets.new(
            filename: options.filename.not_nil!,
            kubectl: Kubectl.new(
              context: options.context,
              namespace: options.namespace,
              kubeconfig: options.kubeconfig
            )
          )

          cmd.run
        end
      end
    end
  end
end

require "./cli/run"
require "./cli/secrets"
require "./cli/template"
