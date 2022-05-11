class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly-staging/archive/v0.1652307093.153118491.tar.gz"
  sha256 "2572cd925ef4a16c1771ad1d6db0cd2d54e712d1aaa1fdbbd5f79a8b0776650d"
  license "BUSL-1.1"
  head "https://github.com/earthly/earthly-staging.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/earthly/homebrew-earthly-staging/releases/download/earthly-0.1651688207.227124570"
    sha256 cellar: :any_skip_relocation, big_sur: "7172064222d8f55df38c04aa04145fd88fed901ac1432a6c506517745fbeacdb"
  end

  depends_on "go@1.17" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=docker.io/earthly/buildkitd:v#{version} -X main.Version=v#{version} -X main.GitSha=920671b5dc5af00995797cdc3aef0d8191a35338 "
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork dfheredoc forceposix"
    system "go", "build",
        "-tags", tags,
        "-ldflags", ldflags,
        *std_go_args,
        "./cmd/earthly/main.go"

    bash_output = Utils.safe_popen_read("#{bin}/earthly", "bootstrap", "--source", "bash")
    (bash_completion/"earthly").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/earthly", "bootstrap", "--source", "zsh")
    (zsh_completion/"_earthly").write zsh_output
  end

  test do
    (testpath/"build.earthly").write <<~EOS

      default:
      \tRUN echo homebrew-earthly-staging
    EOS

    output = shell_output("#{bin}/earthly --version").strip
    assert output.start_with?("earthly version")
  end
end
