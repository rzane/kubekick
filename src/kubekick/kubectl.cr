module Kubekick
  struct Kubectl
    INHERIT = Process::Redirect::Inherit

    CMD = "kubectl"

    class Error < Exception
    end

    def create(template : String)
      Process.run(CMD, ["create", "-f", "-"]) do |process|
        process.input.puts(template)
      end
    end

    def get(resource, name : String)
      status, output, error = run(["get", resource.kind, name, "-o", "yaml"])

      if status.success?
        resource.from_yaml(output.to_s)
      else
        raise Error.new(error.to_s)
      end
    end

    def logs(name : String)
      status, output, error = run(["logs", name])

      if status.success?
        output.to_s
      else
        raise Error.new(error.to_s)
      end
    end

    def run(args)
      output = IO::Memory.new
      error = IO::Memory.new
      status = Process.run(CMD, args, output: output, error: error)
      {status, output, error}
    end
  end
end
