class Reached < Formula
  desc "Manage your Reached network from the terminal"
  homepage "https://reached.marginalutility.dev"
  url "https://github.com/mcclowes/homebrew-reached/releases/download/v0.1.0/reached-0.1.0.tar.gz"
  sha256 "7566809155baa2dfa45b6c1e09acad5a4269a3f34d1e1cf07b94f2f15530ce67"
  license :cannot_represent

  depends_on "node" => :run

  def install
    libexec.install "reached.js"
    (bin/"reached").write_env_script libexec/"reached.js", PATH: "#{Formula["node"].opt_bin}:$PATH"
  end

  test do
    assert_equal "0.1.0", shell_output("#{bin}/reached --version").strip
    assert_match "Usage:", shell_output("#{bin}/reached --help")
  end
end
