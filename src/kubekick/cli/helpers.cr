require "logger"

module Kubekick
  class CLI
    class SecretError < Exception
    end

    module Helpers
      SECRET_NAME = "ejson-keys"

      property output : IO = STDOUT

      def say(message)
        output.puts message
      end

      def read_template(filename)
        if filename == "-"
          STDIN.gets_to_end
        else
          File.read(filename)
        end
      end

      def retrieve_secret_key(public_key)
        secrets = kubectl.get_secrets(SECRET_NAME)
        secrets.value_of(public_key)
      end

      def output_secrets(data)
        if filename == "-" || !replace
          say data
        else
          File.write(filename, data)
          say "secrets updated"
        end
      end

      def refute_secret_exists!
        return unless kubectl.secret_exists?(SECRET_NAME)
        raise SecretError.new("secret '#{SECRET_NAME}' already exists")
      end

      def assert_secret_exists!
        return if kubectl.secret_exists?(SECRET_NAME)
        raise SecretError.new("secret '#{SECRET_NAME}' does not exist")
      end
    end
  end
end
