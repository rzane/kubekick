require "minitest/autorun"
require "../../src/kubekick/cli"

def fixture_file(path)
  File.join(File.expand_path("../fixtures/", __FILE__), path)
end
