
class Laptop < Formula
  desc "Laptop setup and automation scripts"
  homepage "https://github.com/jpolo/laptop"
  head "https://github.com/jpolo/laptop.git"
  license "MIT"

  depends_on "zsh"

  def install
    bin.install "bin/laptop"
    prefix.install Dir["src/*", "profile/*", "README.md"]
  end

  test do
    system "#{bin}/laptop", "--help"
  end
end
