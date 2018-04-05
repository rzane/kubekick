class Kubekick < Formula
  desc "One-off tasks and encrypted secrets CLI for Kubernetes"
  homepage "https://github.com/rzane/kubekick"

  version "0.1.0"
  url "https://github.com/rzane/kubekick/releases/download/v0.1.0/kubekick-0.1.0_darwin_x86_64.tar.gz"
  sha256 "8561e63fd77b062756029cd893515791ea07fc14c0de025edd051834f5adaf15"

  def install
    bin.install "kubekick"
  end

  test do
    cmd = "echo '{{check}}' | #{bin}/kubekick template -f - check=pass"
    assert_equal "pass", shell_output(cmd).chomp
  end
end
