class ParallelGitRepo < Formula
  desc "Run command on git repositories in parallel"
  homepage "https://github.com/jcgay/parallel-git-repo"
  url "https://bintray.com/jcgay/tools/download_file?file_path=v1.0.1%2Fparallel-git-repo-darwin-amd64", :using => :nounzip
  version "1.0.1"
  sha256 "ced09d3c4c62f104116703db25f7278cd6756caed939beb4778df2083129f0e0"

  def install
    bin.install Dir["*"].shift => "parallel-git-repo"
  end
  
  test do
    system "#{bin}/parallel-git-repo", "-h"
  end
end
