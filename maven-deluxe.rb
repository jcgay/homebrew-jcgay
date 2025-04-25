class MavenDeluxe < Formula
  desc "Java-based project management with awesomeness"
  homepage "https://github.com/jcgay/homebrew-jcgay#maven-deluxe"
  url "https://www.apache.org/dyn/closer.lua?path=maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz"
  mirror "https://archive.apache.org/dist/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz"
  sha256 "7a9cdf674fc1703d6382f5f330b3d110ea1b512b51f1652846d9e4e8a588d766"
  version "3.9.9-0"
  
  livecheck do
    url "https://maven.apache.org/download.cgi"
    regex(/href=.*?apache-maven[._-]v?(\d+(?:\.\d+)+)-bin\.t/i)
  end

  depends_on "openjdk"

  conflicts_with "mvnvm", :because => "also installs a 'mvn' executable"

  resource "maven-color-3.0.1" do
    url "https://repo1.maven.org/maven2/fr/jcgay/maven/color/maven-color-gossip/3.0.1/maven-color-gossip-3.0.1-bundle-without-jansi.tar.gz"
    sha256 "3e5bac325b89afc82c96504d8dde35755650042125fbd5af1ee965c315ee43b6"
  end

  resource "maven-notifier-2.1.0" do
    url "https://search.maven.org/remotecontent?filepath=fr/jcgay/maven/maven-notifier/2.1.0/maven-notifier-2.1.0.jar"
    sha256 "884d81c7b3c1584d1577a48bd6eaaa8f1f0960aa2fbe142a7ab732ca0a702832"
  end

  resource "maven-profiler-3.3" do
    url "https://search.maven.org/remotecontent?filepath=fr/jcgay/maven/maven-profiler/3.3/maven-profiler-3.3-shaded.jar"
    sha256 "d235bc3f1d75d3eefde5627f33e7255c3d2f4476bad7f3c60fed6056a54f6f87"
  end

  def install
    # Remove windows files
    rm(Dir["bin/*.cmd"])

    # Fix the permissions on the global settings file.
    chmod 0644, "conf/settings.xml"

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
    rm(Dir[libexec/"lib/maven-slf4j-provider*"])

    resource("maven-color-3.0.1").stage { (libexec/"lib/ext").install Dir["ext/*"] }
    resource("maven-notifier-2.1.0").stage { (libexec/"lib/ext").install Dir["*"] }
    resource("maven-profiler-3.3").stage { (libexec/"lib/ext").install Dir["*"] }
  end

  test do
    (testpath/"pom.xml").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <project xmlns="https://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="https://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
        <modelVersion>4.0.0</modelVersion>
        <groupId>org.homebrew</groupId>
        <artifactId>maven-test</artifactId>
        <version>1.0.0-SNAPSHOT</version>
        <properties>
          <maven.compiler.source>1.8</maven.compiler.source>
          <maven.compiler.target>1.8</maven.compiler.target>
          <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        </properties>
      </project>
    XML

    (testpath/"src/main/java/org/homebrew/MavenTest.java").write <<~JAVA
      package org.homebrew;
      public class MavenTest {
        public static void main(String[] args) {
          System.out.println("Testing Maven with Homebrew!");
        }
      }
    JAVA

    system bin/"mvn", "compile", "-Duser.home=#{testpath}"
  end
end
