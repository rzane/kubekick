class Kubekick < Formula
  desc "One-off tasks and encrypted secrets CLI for Kubernetes"
  homepage "https://gitlab.com/rzane/kubekick"
  url "https://gitlab.com/rzane/kubekick/repository/v0.1.0/archive.tar.gz"
  sha256 "ed33da4366c64fee548b3f32f1217294ad617004578ddd5d843a8a5c3cefde2e"
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
