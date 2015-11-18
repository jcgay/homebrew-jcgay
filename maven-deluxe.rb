class MavenDeluxe < Formula
  desc "Java-based project management with awesomeness"
  homepage "https://github.com/jcgay/homebrew-jcgay#maven-deluxe"
  url "https://www.apache.org/dyn/closer.cgi?path=maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz"
  mirror "https://archive.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz"
  sha256 "6e3e9c949ab4695a204f74038717aa7b2689b1be94875899ac1b3fe42800ff82"
  version "3.3.9-0"

  resource 'maven-color-1.2' do
    url 'http://dl.bintray.com/jcgay/maven/com/github/jcgay/maven/color/maven-color-logback/1.2/maven-color-logback-1.2-bundle.tar.gz'
    sha1 '0042549352d6f7ea36de2558d6e12ba7ea15679e'
  end
  
  resource 'maven-notifier-1.8' do
    url 'http://dl.bintray.com/jcgay/maven/fr/jcgay/maven/maven-notifier/1.8/maven-notifier-1.8-shaded.jar'
    sha1 '04176f1be1123cdc1ad7db95d51949cf29802d79'
  end
  
  resource 'maven-profiler-2.4' do
    url 'http://dl.bintray.com/jcgay/maven/fr/jcgay/maven/maven-profiler/2.4/maven-profiler-2.4-shaded.jar'
    sha1 '25e6a2d42bb82a8ebf995ac998e111a9a07a6cec'
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
    resource("maven-color-1.2").stage { system "cp", "-r", ".", libexec }
    inreplace "#{libexec}/conf/logging/logback.xml" do |s|
      s.gsub! "[%replace(%level){'WARN','WARNING'}] ", ""
    end
    
    resource("maven-notifier-1.8").stage { (libexec/"lib/ext").install Dir["*"] }
    
    resource("maven-profiler-2.4").stage { (libexec/"lib/ext").install Dir["*"] }    
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
    system "#{bin}/mvn", "compile", "-Duser.home=#{testpath}"
  end
end
