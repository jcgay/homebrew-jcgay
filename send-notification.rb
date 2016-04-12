class SendNotification < Formula
  desc "Command Line to send notifications"
  homepage "https://github.com/jcgay/send-notification"
  url "https://bintray.com/artifact/download/jcgay/maven/fr/jcgay/send-notification/send-notification-cli/0.10.1/send-notification-cli-0.10.1-binaries.zip"
  version "0.10.1"
  sha256 "3974bde3a1825dfa509bbfab66b46f66518bf2ca38463eae9d4245a8277ead49"
  
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
