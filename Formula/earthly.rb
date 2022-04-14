class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly-staging/archive/v0.1649894144.8254452.tar.gz"
  sha256 "bed2a80dd77e2acd6bdfaf561a9706a3d7392339906ca92b997420c22c612f3b"
  license "BUSL-1.1"
  head "https://github.com/earthly/earthly-staging.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/earthly/homebrew-earthly-staging/releases/download/earthly-0.1649894144.8254452"
    sha256 cellar: :any_skip_relocation, big_sur: "9ed0897bdc5b2d56116483d96917294dc179519b52e66b2c5782be7f254c494b"
  end

  depends_on "go@1.17" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=docker.io/earthly/buildkitd:v#{version} -X main.Version=v#{version} -X main.GitSha=07df3f47c06023ac37795b7397ec22710d7443d8 "
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
