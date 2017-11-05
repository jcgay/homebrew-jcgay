class SendNotification < Formula
  desc "Command Line to send notifications"
  homepage "https://github.com/jcgay/send-notification"
  url "https://bintray.com/artifact/download/jcgay/maven/fr/jcgay/send-notification/send-notification-cli/0.14.0/send-notification-cli-0.14.0-binaries.zip"
  version "0.14.0"
  sha256 "11a559cf45c1b3ecde8fb2b5ddd26abae8cb4ee682652c423a3b7ccd2e56eafc"
  
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
