class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly-staging/archive/v0.1648663119.2253833797.tar.gz"
  sha256 "b38df9b7bf171ea4a288bac919b288c7fdcd0ecac63a426cc79fc76a78bdc196"
  license "BUSL-1.1"
  head "https://github.com/earthly/earthly-staging.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/earthly/homebrew-earthly-staging/releases/download/earthly-0.1648663119.2253833797"
    sha256 cellar: :any_skip_relocation, big_sur: "7f6513aae7126352e24693193509db04b2e13d59f99f8e5a05b8461a197b31c9"
  end

  depends_on "go@1.17" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=docker.io/earthly/buildkitd:v#{version} -X main.Version=v#{version} -X main.GitSha=8656c645a89d95c49068e23cc94c51c861a0c629 "
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
