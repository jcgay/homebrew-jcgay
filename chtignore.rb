class Chtignore < Formula
  desc "Print .gitignore template from https://github.com/github/gitignore in standard output"
  homepage "https://github.com/jcgay/chtignore"
  url "https://bintray.com/artifact/download/jcgay/tools/chtignore_1.1.0_darwin_amd64.zip"
  sha256 "64b6491b3e90c673ca1c1183959f56f6bc8e4d76e39f3fe583431cfb9a42fc69"
  version "1.1.0"

  def install
    bin.install "chtignore"
  end

  test do
    system "#{bin}/chtignore", "-h"
  end
end