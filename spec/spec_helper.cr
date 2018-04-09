require "minitest/autorun"
require "../../src/kubekick/cli"

PUBLIC_KEY = "870c8b7867009b93652549c4144cd425bd03043a36e207cce13411d260385732"
PRIVATE_KEY = "1d59c0892d42cd5959dd6b8e8b04f1a0061a4c4901e075bad291c109aeac1688"

def fixture_file(path)
  File.join(File.expand_path("../fixtures/", __FILE__), path)
end
