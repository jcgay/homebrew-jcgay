class Gw < Formula
    desc "Gradle Wrapper with interactive cli"
    homepage "https://github.com/jcgay/gw"
    url "https://github.com/jcgay/gw/releases/download/v0.1/gw-refs.tags.v0.1.zip"
    version "0.1"
    sha256 "11355745b7aaafa8dcaa0a3c5516f582eadebdd188f9e1812b10864e481cbe32"
    
    def install
      # Remove windows files
      rm_f Dir["bin/*.bat"]
      
      libexec.install Dir["*"]
      
      bin.install_symlink "#{libexec}/bin/gw"
    end
  end
  