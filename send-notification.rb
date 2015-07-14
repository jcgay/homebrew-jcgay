class SendNotification < Formula
  desc "Command Line to send notifications"
  homepage "https://github.com/jcgay/send-notification"
  url "https://repo1.maven.org/maven2/fr/jcgay/send-notification/send-notification-cli/0.6/send-notification-cli-0.6-binaries.zip"
  version "0.6"
  sha256 "4c9fc72fdd40391e01f34d0c503e976ff1826969e375dfaa4a677f6b2ec04f0f"
  
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
