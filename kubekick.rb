class Kubekick < Formula
  desc "One-off tasks and encrypted secrets CLI for Kubernetes"
  homepage "https://gitlab.com/rzane/kubekick"
  url "https://gitlab.com/rzane/kubekick/repository/v0.1.0/archive.tar.gz"
  sha256 "aa04f2e39150923e8380bf498f6b191a6c03823faa60d099537937a70ee3717b"
  head "https://gitlab.com/rzane/kubekick.git"

  depends_on "crystal-lang" => :build
  depends_on "libsodium"

  def install
    system "make"
    prefix.install "bin/kubekick"
  end

  test do
    system "#{bin}/kubekick", "--version"
  end
end
