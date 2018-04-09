require "../../ejson"

module Kubekick
  class CLI
    module Secrets
      module Helpers
        SECRET_NAME = "ejson-keys"

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
      end
    end
  end
end
