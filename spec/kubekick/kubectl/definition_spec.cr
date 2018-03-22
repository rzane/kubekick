require "minitest/autorun"
require "../../../src/kubekick/kubectl/definition"

describe Kubekick::Kubectl::Definition do
  include Kubekick

  describe "yaml" do
    let :yaml do
      <<-DATA
      metadata:
        name: foo
      DATA
    end

    let :definition do
      Kubectl::Definition.new(yaml)
    end

    it "has a uuid" do
      definition.uuid.wont_be_nil
    end

    it "has a name" do
      definition.name.must_equal "foo-#{definition.uuid}"
    end

    it "dumps yaml with new name" do
      data = YAML.parse definition.dump
      name = data["metadata"]["name"].as_s
      name.must_equal definition.name
    end
  end

  describe "json" do
    let :json do
      <<-DATA
      {
        "metadata": {
          "name": "foo"
        }
      }
      DATA
    end

    let :definition do
      Kubectl::Definition.new(json)
    end

    it "has a uuid" do
      definition.uuid.wont_be_nil
    end

    it "has a name" do
      definition.name.must_equal "foo-#{definition.uuid}"
    end

    it "dumps yaml with new name" do
      data = YAML.parse definition.dump
      name = data["metadata"]["name"].as_s
      name.must_equal definition.name
    end
  end
end
