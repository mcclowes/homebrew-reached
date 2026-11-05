class Reached < Formula
  desc "Manage your Reached network from the terminal"
  homepage "https://reached.marginalutility.dev"
  url "https://github.com/mcclowes/homebrew-reached/releases/download/v0.3.0/reached-0.3.0.tar.gz"
  sha256 "1ee6d8f2e5ffdd90c54dd29c690b1138bb58dfc25f7d6bb80689f46d71812590"
  license :cannot_represent

  depends_on "node" => :run

  def install
    libexec.install Dir["*.js"]
    (bin/"reached").write_env_script libexec/"reached.js", PATH: "#{Formula["node"].opt_bin}:$PATH"
  end

  test do
    assert_equal "0.3.0", shell_output("#{bin}/reached --version").strip
    assert_match "Usage:", shell_output("#{bin}/reached --help")
  end
end
