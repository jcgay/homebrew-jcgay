class SendNotification < Formula
  desc "Command Line to send notifications"
  homepage "https://github.com/jcgay/send-notification"
  url "https://repo1.maven.org/maven2/fr/jcgay/send-notification/send-notification-cli/0.8/send-notification-cli-0.8-binaries.zip"
  version "0.8"
  sha256 "b5fff6b2e348c28f74c780fbcd4372834d9ac1c73a23f4527ec844e49ff18616"
  
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
