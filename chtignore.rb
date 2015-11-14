class Chtignore < Formula
  desc "Print .gitignore template from https://github.com/github/gitignore in standard output"
  homepage "https://github.com/jcgay/chtignore"
  url "https://bintray.com/artifact/download/jcgay/tools/chtignore_1.0.0_darwin_amd64.zip"
  sha256 "87fd82bce0fd177f3d1ae96649bb57b1ec1d134a0b9f58db06306cfac7ac48c6"
  version "1.0.0"

  def install
    bin.install "chtignore"
  end

  test do
    system "#{bin}/chtignore", "-h"
  end
end