class SendNotification < Formula
  desc "Command Line to send notifications"
  homepage "https://github.com/jcgay/send-notification"
  url "https://bintray.com/artifact/download/jcgay/maven/fr/jcgay/send-notification/send-notification-cli/0.13.0/send-notification-cli-0.13.0-binaries.zip"
  version "0.13.0"
  sha256 "00b4b106d88f3cf0c405fbcf414cd852a156b0ec4e5a2f33fadd1d6f9340bb4f"
  
  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]
    
    libexec.install Dir["*"]
    
    bin.install_symlink "#{libexec}/bin/send-notification"
  end
  
  test do
    system "#{bin}/send-notification", "-h"
  end
end
