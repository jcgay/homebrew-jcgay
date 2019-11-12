class Gw < Formula
    desc "Gradle Wrapper with interactive cli"
    homepage "https://github.com/jcgay/gw"
    url "https://github.com/jcgay/gw/releases/download/v0.2/gw-refs.tags.v0.2.zip"
    version "0.2"
    sha256 "088b4b3ba18dcb0888280c33a34a067ef76f25484b7fcd8c9b1ff9cdcd72b422"
    
    def install
      # Remove windows files
      rm_f Dir["bin/*.bat"]
      
      libexec.install Dir["*"]
      
      bin.install_symlink "#{libexec}/bin/gw"
    end
  end
  