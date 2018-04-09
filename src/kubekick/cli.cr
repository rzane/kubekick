require "clim"
require "./kubectl"
require "./version"

module Kubekick
  class CLI < Clim
    macro kubernetes_command
      option "-n NAMESPACE", "--namespace NAMESPACE",
        type: String,
        desc: "The namespace scope"

      option "--context CONTEXT",
        type: String,
        desc: "The name of the kubeconfig context"

      option "--kubeconfig KUBECONFIG",
        type: String,
        desc: "Path to the kubeconfig file"
    end

    def self.kubectl(options)
      Kubectl.new(
        context: options.context,
        namespace: options.namespace,
        kubeconfig: options.kubeconfig
      )
    end

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
          type: Array(String),
          desc: "Template files",
          required: true

        option "--from FILE",
          type: Array(String),
          desc: "Path to a YAML/JSON file containing parameters",
          default: [] of String

        run do |options, arguments|
          CLI::Template.new(
            filenames: options.filename.not_nil!,
            from: options.from,
            parameters: arguments
          ).run
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

        CLI.kubernetes_command

        option "-f FILE", "--filename FILE",
          type: String,
          desc: "Filename to use to create the resource",
          required: true

        run do |options, arguments|
          CLI::Run.new(
            filename: options.filename.not_nil!,
            kubectl: CLI.kubectl(options)
          ).run
        end
      end

      sub_command "secrets" do
        desc "Manage Kubernetes secrets"
        usage "kubekick secrets [command] [arguments]"
        run do |options, _arguments|
          puts options.help
        end

        sub_command "provision" do
          desc "Generate a keypair and store the private key in Kubernetes"

          CLI.kubernetes_command

          run do |options, _arguments|
            CLI::Secrets::Provision.new(kubectl: CLI.kubectl(options)).run
          end
        end

        sub_command "encrypt" do
          desc "Encrypt the values in a given file using the keypair stored in Kubernetes."

          CLI.kubernetes_command

          option "-f FILE", "--filename FILE",
            type: String,
            desc: "Filename to use to create the resource",
            required: true

          option "--replace",
            type: Bool,
            desc: "Edit the file inline",
            default: false

          run do |options, _arguments|
            CLI::Secrets::Encrypt.new(
              filename: options.filename.not_nil!,
              replace: options.replace,
              kubectl: CLI.kubectl(options)
            ).run
          end
        end

        sub_command "decrypt" do
          desc "Decrypt the values in a given file using the keypair stored in Kubernetes."

          CLI.kubernetes_command

          option "-f FILE", "--filename FILE",
            type: String,
            desc: "Filename to use to create the resource",
            required: true

          option "--replace",
            type: Bool,
            desc: "Replace the contents of the file",
            default: false

          run do |options, _arguments|
            CLI::Secrets::Decrypt.new(
              filename: options.filename.not_nil!,
              replace: options.replace,
              kubectl: CLI.kubectl(options)
            ).run
          end
        end

        sub_command "deploy" do
          CLI.kubernetes_command

          desc "Synchronize a secrets file with Kubernetes"
          usage <<-USAGE
          Load a JSON file:

                kubekick secrets -f path/to/file.json

              Alternatively, you can pipe the JSON in:

                cat path/to/secrets.json | kubekick secrets -f -
          USAGE

          option "-f FILE", "--filename FILE",
            type: String,
            desc: "Filename to use to create the resource",
            required: true

          run do |options, arguments|
            CLI::Secrets::Deploy.new(
              filename: options.filename.not_nil!,
              kubectl: CLI.kubectl(options)
            ).run
          end
        end
      end
    end
  end
end

require "./cli/run"
require "./cli/secrets/provision"
require "./cli/secrets/encrypt"
require "./cli/secrets/decrypt"
require "./cli/secrets/deploy"
require "./cli/template"
