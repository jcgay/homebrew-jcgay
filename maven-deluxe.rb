class MavenDeluxe < Formula
  desc "Java-based project management with awesomeness"
  homepage "https://github.com/jcgay/homebrew-jcgay#maven-deluxe"
  url "https://www.apache.org/dyn/closer.cgi?path=maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz"
  mirror "https://archive.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz"
  sha256 "6e3e9c949ab4695a204f74038717aa7b2689b1be94875899ac1b3fe42800ff82"
  version "3.3.9-4"

  resource 'maven-color-1.4.1' do
    url 'http://dl.bintray.com/jcgay/maven/com/github/jcgay/maven/color/maven-color-logback/1.4.1/maven-color-logback-1.4.1-bundle.tar.gz'
    sha256 'f5fd594d1cbeba136bc79dfb43a876c5fa49083f97e37fbec81df65dfc87a25b'
  end
  
  resource 'maven-notifier-1.9.1' do
    url 'http://dl.bintray.com/jcgay/maven/fr/jcgay/maven/maven-notifier/1.9.1/maven-notifier-1.9.1-shaded.jar'
    sha256 'ed6fbb0bffc633cf43b4f52d8aae33ac1ce313f7528ca4aecaa75559f8a3bfd5'
  end
  
  resource 'maven-profiler-2.4' do
    url 'http://dl.bintray.com/jcgay/maven/fr/jcgay/maven/maven-profiler/2.4/maven-profiler-2.4-shaded.jar'
    sha256 '2ede9a5f5646ba853dd1926142b0f69fdfabdb08926bf403746fcd4f7f433eed'
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

    resource("maven-color-1.4.1").stage { system "cp", "-r", ".", libexec }    
    resource("maven-notifier-1.9.1").stage { (libexec/"lib/ext").install Dir["*"] }
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
