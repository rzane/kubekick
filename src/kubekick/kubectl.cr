require "./kubectl/pod"
require "./kubectl/secret"
require "./kubectl/definition"

module Kubekick
  class Kubectl
    CMD = "kubectl"
    INHERIT = Process::Redirect::Inherit

    class Error < Exception
    end

    def initialize(context = nil, namespace = nil, kubeconfig = nil)
      @flags = [] of String
      @flags << "--context" << context unless context.nil?
      @flags << "--namespace" << namespace unless namespace.nil?
      @flags << "--kubeconfig" << kubeconfig unless kubeconfig.nil?
    end

    def create_pod(template : String)
      Process.run(CMD, @flags + ["create", "-f", "-"]) do |process|
        process.input.puts(template)
      end
    end

    def get_pod(name : String)
      status, output, error = run(["get", "pod", name, "-o", "yaml"])

      if status.success?
        Pod.new(output.to_s)
      else
        raise Error.new(error.to_s)
      end
    end

    def delete_pod(name : String)
      status, _, error = run(["delete", "pod", name])
      raise Error.new(error.to_s) unless status.success?
    end

    def run(args)
      output = IO::Memory.new
      error = IO::Memory.new
      status = Process.run(CMD, @flags + args, output: output, error: error)
      {status, output, error}
    end
  end
end
