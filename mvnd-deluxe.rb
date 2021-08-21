class MvndDeluxe < Formula
  desc "Maven Daemon with awesomeness"
  homepage "https://github.com/jcgay/homebrew-jcgay#mvnd-deluxe"
  version "0.5.2-0"
  on_macos do
    url "https://github.com/mvndaemon/mvnd/releases/download/0.5.2/mvnd-0.5.2-darwin-amd64.zip"
    sha256 "1cb17e9d192a801d69634305bd6e15a9f805a257fc813df793d0e6fb16630635"
  end
  on_linux do
    url "https://github.com/mvndaemon/mvnd/releases/download/0.5.2/mvnd-0.5.2-linux-amd64.zip"
    sha256 "55201c347a95a6df7600d988cc3ab71323f5eef627a1a3e9808ed2212c5a0987"
  end

  livecheck do
    url :stable
  end

  bottle :unneeded

  depends_on "openjdk" => :recommended
  
  resource "maven-notifier-2.1.2" do
    url "https://repo1.maven.org/maven2/fr/jcgay/maven/maven-notifier/2.1.2/maven-notifier-2.1.2.jar"
    sha256 "4f400379553e12e3307b35b43bd005e80b14043d1787015d3a9ce32eb27c3bb3"
  end

  resource "maven-profiler-3.1.1" do
    url "https://repo1.maven.org/maven2/fr/jcgay/maven/maven-profiler/3.1.1/maven-profiler-3.1.1-shaded.jar"
    sha256 "32bd0004c86ba82c83ad8b86035e5520ccc87307c2089c946f573cc6ebc47de0"
  end

  def install
    # Remove windows files
    rm_f Dir["bin/*.cmd"]

    # Replace mvnd by using mvnd.sh
    if Hardware::CPU.arm?
      mv "bin/mvnd.sh", "bin/mvnd", force: true
    end

    libexec.install Dir["*"]

    Pathname.glob("#{libexec}/bin/*") do |file|
      next if file.directory?

      basename = file.basename
      (bin/basename).write_env_script file, Language::Java.overridable_java_home_env
    end

    daemon = var + 'run/mvnd'
    FileUtils.mkdir_p "#{daemon}", mode: 0775 unless daemon.exist?
    FileUtils.ln_sf(daemon, libexec + 'daemon')
    
    resource("maven-notifier-2.1.2").stage { (libexec/"mvn/lib/ext").install Dir["*"] }
    resource("maven-profiler-3.1.1").stage { (libexec/"mvn/lib/ext").install Dir["*"] }
  end

  test do
    (testpath/"settings.xml").write <<~EOS
      <settings><localRepository>#{testpath}/repository</localRepository></settings>
    EOS
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
    system "#{bin}/mvnd", "-gs", "#{testpath}/settings.xml", "compile"
  end
end
