class ParallelGitRepo < Formula
  desc "Run command on git repositories in parallel"
  homepage "https://github.com/jcgay/parallel-git-repo"
  url "https://bintray.com/jcgay/tools/download_file?file_path=parallel-git-repo-darwin-amd64", :using => :nounzip
  version "1.0.0"
  sha256 "2c41419e8d4617abc5ea342e2b35a756a22bb320be5603130b1225b2079053b7"

  def install
    bin.install Dir["*"].shift => "parallel-git-repo"
  end
end
