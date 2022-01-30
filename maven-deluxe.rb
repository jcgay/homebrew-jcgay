class MavenDeluxe < Formula
  desc "Java-based project management with awesomeness"
  homepage "https://github.com/jcgay/homebrew-jcgay#maven-deluxe"
  url "https://www.apache.org/dyn/closer.lua?path=maven/maven-3/3.8.4/binaries/apache-maven-3.8.4-bin.tar.gz"
  mirror "https://archive.apache.org/dist/maven/maven-3/3.8.4/binaries/apache-maven-3.8.4-bin.tar.gz"
  sha256 "2cdc9c519427bb20fdc25bef5a9063b790e4abd930e7b14b4e9f4863d6f9f13c"
  version "3.8.4-1"
  
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

  resource "maven-profiler-3.2" do
    url "https://search.maven.org/remotecontent?filepath=fr/jcgay/maven/maven-profiler/3.2/maven-profiler-3.2-shaded.jar"
    sha256 "089e7ce16e05d0028189eda5dea77ecc0d675acd862839e2a4d8864bb05e8399"
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

    resource("maven-color-3.0.1").stage { (libexec/"lib/ext").install Dir["ext/*"] }
    resource("maven-notifier-2.1.0").stage { (libexec/"lib/ext").install Dir["*"] }
    resource("maven-profiler-3.2").stage { (libexec/"lib/ext").install Dir["*"] }
  end

  test do
    (testpath/"pom.xml").write <<~EOS
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
    EOS
    (testpath/"src/main/java/org/homebrew/MavenTest.java").write <<~EOS
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
