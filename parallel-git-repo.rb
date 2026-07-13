class ParallelGitRepo < Formula
  desc "Run command on git repositories in parallel"
  homepage "https://github.com/jcgay/parallel-git-repo"
  url "https://github.com/jcgay/parallel-git-repo/releases/download/v1.0.1/parallel-git-repo-darwin-amd64", :using => :nounzip
  version "1.0.1"
  sha256 "7940a9d685bbb4b7e962504ce460767a1857d987c81fd1871bc8327043ac6cfd"

  def install
    bin.install Dir["*"].shift => "parallel-git-repo"
  end
  
  test do
    system "#{bin}/parallel-git-repo", "-h"
  end
end
