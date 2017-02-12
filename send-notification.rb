class SendNotification < Formula
  desc "Command Line to send notifications"
  homepage "https://github.com/jcgay/send-notification"
  url "https://bintray.com/artifact/download/jcgay/maven/fr/jcgay/send-notification/send-notification-cli/0.10.2/send-notification-cli-0.10.2-binaries.zip"
  version "0.10.2"
  sha256 "e79f258ca6d45c37d5ccd48bd7b1081414d11808dcbd4090ade1aa635451c774"
  
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
