class MavenDeluxe < Formula
  desc "Java-based project management with awesomeness"
  homepage "https://github.com/jcgay/homebrew-jcgay#maven-deluxe"
  url "https://www.apache.org/dyn/closer.cgi?path=maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz"
  mirror "https://archive.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz"
  version "3.6.3-0"
  sha256 "26ad91d751b3a9a53087aefa743f4e16a17741d3915b219cf74112bf87a438c5"

  bottle :unneeded

  depends_on "openjdk"

  conflicts_with "mvnvm", :because => "also installs a 'mvn' executable"

  resource "maven-color-2.1.1" do
    url "https://dl.bintray.com/jcgay/maven/com/github/jcgay/maven/color/maven-color-gossip/2.1.1/maven-color-gossip-2.1.1-bundle-without-jansi.tar.gz"
    sha256 "047b7e154f359d0c27a8160b07406494dda761c97943f40ed7c6ef5ea4cc38d8"
  end

  resource "maven-notifier-2.1.0" do
    url "https://dl.bintray.com/jcgay/maven/fr/jcgay/maven/maven-notifier/2.1.0/maven-notifier-2.1.0.jar"
    sha256 "884d81c7b3c1584d1577a48bd6eaaa8f1f0960aa2fbe142a7ab732ca0a702832"
  end

  resource "maven-profiler-3.0" do
    url "https://dl.bintray.com/jcgay/maven/fr/jcgay/maven/maven-profiler/3.0/maven-profiler-3.0-shaded.jar"
    sha256 "dd74443f1f7fcea414ad133b8b6e86e9c3d6c5271a6301b1519b3662bddf13b8"
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

    resource("maven-color-2.1.1").stage { (libexec/"lib/ext").install Dir["ext/*"] }
    resource("maven-notifier-2.1.0").stage { (libexec/"lib/ext").install Dir["*"] }
    resource("maven-profiler-3.0").stage { (libexec/"lib/ext").install Dir["*"] }
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
