class Kubekick < Formula
  desc "One-off tasks and encrypted secrets CLI for Kubernetes"
  homepage "https://gitlab.com/rzane/kubekick"
  url "https://gitlab.com/rzane/kubekick/repository/v0.1.0/archive.tar.gz"
  sha256 "51343e7a776c3764fc5c2e1595739f823d683f36c13fb999344c2728d164b22e"
  head "https://gitlab.com/rzane/kubekick.git"

  depends_on "crystal-lang" => :build
  depends_on "libsodium"

  def install
    system "make"
    bin.install "bin/kubekick"
  end

  test do
    system "#{bin}/kubekick", "--version"
  end
end
