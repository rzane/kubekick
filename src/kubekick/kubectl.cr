require "tempfile"
require "./kubectl/pod"
require "./kubectl/secret"
require "./kubectl/definition"

module Kubekick
  class Kubectl
    CMD = "kubectl"

    class Error < Exception
    end

    def initialize(context = nil, namespace = nil, kubeconfig = nil)
      @flags = [] of String
      @flags << "--context" << context unless context.nil?
      @flags << "--namespace" << namespace unless namespace.nil?
      @flags << "--kubeconfig" << kubeconfig unless kubeconfig.nil?
    end

    def create(name : String, template : String)
      with_tempfile(name, template) do |path|
        run!(["create", "-f", path])
      end
    end

    def apply(name : String, template : String)
      with_tempfile(name, template) do |path|
        run!(["apply", "-f", path])
      end
    end

    def get_pod(name : String)
      Pod.new run!(["get", "pod", name, "-o", "yaml"])
    end

    def delete_pod(name : String)
      run!(["delete", "pod", name])
    end

    def get_secrets(name : String)
      Secret.new run!(["get", "secret", name, "-o", "yaml"])
    end

    private def with_tempfile(name, contents)
      file = Tempfile.new(name)
      file.print(contents)
      file.close
      yield file.path
    ensure
      file.unlink unless file.nil?
    end

    private def run!(args)
      output = IO::Memory.new
      error = IO::Memory.new
      status = Process.run(
        CMD,
        @flags + args,
        output: output,
        error: error
      )

      if status.success?
        output.to_s
      else
        raise Error.new(error.to_s)
      end
    end
  end
end
