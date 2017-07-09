class MavenDeluxe < Formula
  desc "Java-based project management with awesomeness"
  homepage "https://github.com/jcgay/homebrew-jcgay#maven-deluxe"
  url "https://www.apache.org/dyn/closer.cgi?path=maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz"
  version "3.5.0-2"
  sha256 "beb91419245395bd69a4a6edad5ca3ec1a8b64e41457672dc687c173a495f034"

  bottle :unneeded

  depends_on :java

  conflicts_with "mvnvm", :because => "also installs a 'mvn' executable"

  resource "maven-color-2.0.0" do
    url "https://dl.bintray.com/jcgay/maven/com/github/jcgay/maven/color/maven-color-gossip/2.0.0/maven-color-gossip-2.0.0-bundle.tar.gz"
    sha256 "99d87602e5b9d1564952b756d7c5efe2f1ca0b9b443db0c977c57e6dfbaa77bd"
  end

  resource "maven-notifier-1.10.1" do
    url "https://dl.bintray.com/jcgay/maven/fr/jcgay/maven/maven-notifier/1.10.1/maven-notifier-1.10.1.jar"
    sha256 "a5707c87b8ca5f6b2cec052fd1d6e66dc4a866615ccc2b7140afe5d8e6ed9f48"
  end

  resource "maven-profiler-2.6" do
    url "https://dl.bintray.com/jcgay/maven/fr/jcgay/maven/maven-profiler/2.6/maven-profiler-2.6-shaded.jar"
    sha256 "fac9cdec4ba23eb1d73b8514b601aeae752f8657d140a862870f49172d599221"
  end

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Fix the permissions on the global settings file.
    chmod 0644, "conf/settings.xml"

    prefix.install_metafiles
    libexec.install Dir["*"]

    # Leave conf file in libexec. The mvn symlink will be resolved and the conf
    # file will be found relative to it
    Pathname.glob("#{libexec}/bin/*") do |file|
      next if file.directory?
      basename = file.basename
      next if basename.to_s == "m2.conf"
      (bin/basename).write_env_script file, Language::Java.overridable_java_home_env
    end

    # Remove slf4j-simple
    rm_f Dir[libexec/"lib/maven-slf4j-provider*"]

    resource("maven-color-2.0.0").stage { (libexec/"lib/ext").install Dir["ext/*"] }
    resource("maven-notifier-1.10.1").stage { (libexec/"lib/ext").install Dir["*"] }
    resource("maven-profiler-2.6").stage { (libexec/"lib/ext").install Dir["*"] }
  end

  test do
    (testpath/"pom.xml").write <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
        <modelVersion>4.0.0</modelVersion>
        <groupId>org.homebrew</groupId>
        <artifactId>maven-test</artifactId>
        <version>1.0.0-SNAPSHOT</version>
      </project>
    EOS
    (testpath/"src/main/java/org/homebrew/MavenTest.java").write <<-EOS.undent
      package org.homebrew;
      public class MavenTest {
        public static void main(String[] args) {
          System.out.println("Testing Maven with Homebrew!");
        }
      }
    EOS
    system "#{bin}/mvn", "compile", "-Duser.home=#{testpath}"
  end
end
