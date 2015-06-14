class MavenDeluxe < Formula
  desc "Java-based project management with awesomeness"
  homepage "https://maven.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz"
  mirror "https://archive.apache.org/dist/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz"
  sha256 "3a8dc4a12ab9f3607a1a2097bbab0150c947ad6719d8f1bb6d5b47d0fb0c4779"
  version "3.3.3-1"

  resource 'maven-color' do
    url 'http://dl.bintray.com/jcgay/maven/com/github/jcgay/maven/color/maven-color-logback/1.1/maven-color-logback-1.1-bundle.tar.gz'
    sha1 '2b4ae0c3f83a73843053a882519ebc2ef572a8d2'
  end
  
  resource 'maven-notifier' do
    url 'http://dl.bintray.com/jcgay/maven/fr/jcgay/maven/maven-notifier/1.4/maven-notifier-1.4-shaded.jar'
    sha1 'c48a2d62bbc0a86d907147724dae48613f26ca52'
  end
  
  resource 'maven-profiler' do
    url 'http://dl.bintray.com/jcgay/maven/fr/jcgay/maven/maven-profiler/2.2/maven-profiler-2.2-shaded.jar'
    sha1 '201b49b6ebc2438ff61fc1d74cbefefa8256efa3'
  end
  
  resource 'maven-core-patch' do
    url 'http://jeanchristophegay.com/binaries/maven-core-3.3.3.jar'
    sha1 'cca6f23c26aeb2cec2f869fc3cc54716c86906f5'
  end

  depends_on :java

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
    rm_f Dir[libexec/"lib/slf4j-simple*"]
    resource("maven-color").stage { system "cp", "-r", ".", libexec }
    inreplace "#{libexec}/conf/logging/logback.xml" do |s|
      s.gsub! "[%replace(%level){'WARN','WARNING'}] ", ""
    end
    # https://github.com/jcgay/maven-color/issues/10
    resource("maven-core-patch").stage { (libexec/"lib").install Dir["*"] }
    
    resource("maven-notifier").stage { (libexec/"lib/ext").install Dir["*"] }
    
    resource("maven-profiler").stage { (libexec/"lib/ext").install Dir["*"] }    
  end

  conflicts_with "mvnvm", :because => "also installs a 'mvn' executable"

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
    system "#{bin}/mvn", "compile"
  end
end
