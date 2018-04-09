require "../../spec_helper"

describe Kubekick::CLI::Template do
  include Kubekick

  let :filename do
    fixture_file("template/task.yaml").as String
  end

  let :variables do
    fixture_file("template/vars.yaml").as String
  end

  describe "using arguments" do
    let :cli do
      CLI::Template.new(
        filenames: [filename],
        parameters: ["image=foobar"],
        from: [] of String
      )
    end

    before do
      cli.output = IO::Memory.new
    end

    it "replaces values" do
      cli.run
      cli.output.to_s.must_match(/image: foobar/)
    end
  end

  describe "using variables file" do
    let :cli do
      CLI::Template.new(
        filenames: [filename],
        parameters: [] of String,
        from: [variables]
      )
    end

    before do
      cli.output = IO::Memory.new
    end

    it "replaces values" do
      cli.run
      cli.output.to_s.must_match(/image: alpine:3\.6/)
    end
  end
end
