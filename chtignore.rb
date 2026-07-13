class Chtignore < Formula
  desc "Print .gitignore template from https://github.com/github/gitignore in standard output"
  homepage "https://github.com/jcgay/chtignore"
  url "https://github.com/jcgay/chtignore/releases/download/v1.1.0/chtignore_1.1.0_darwin_amd64.zip"
  sha256 "1dd6488e8f8fb13203c1991bdba0aa615b2946e3667dd7176fe68c2697dc42b9"
  version "1.1.0"

  def install
    bin.install "chtignore"
  end

  test do
    system "#{bin}/chtignore", "-h"
  end
end