class NotifySh < Formula
  desc "Display desktop notifications when a task finishes"
  homepage "https://github.com/jcgay/notify.sh"
  url "https://github.com/jcgay/notify.sh/archive/v1.0.tar.gz"
  version "1.0"
  sha256 "b0f372ce64225c0c771458645a3e8e24bc21dc73c7c340f106a686cd7b739069"

  depends_on "send-notification"

  def install
    libexec.install Dir["*"]

    bin.install_symlink "#{libexec}/notify"
  end

  test do
    system "#{bin}/notify", "-h"
  end
end
