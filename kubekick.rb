class Kubekick < Formula
  desc "One-off tasks and encrypted secrets CLI for Kubernetes"
  homepage "https://gitlab.com/rzane/kubekick"
  url "https://github.com/rzane/kubekick/archive/v0.1.0.zip"
  sha256 "507df4504b350ee141c1b3085b42de37219ecc584c1bc8b9ae717543de7cf2f0"
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
