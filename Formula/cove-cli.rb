class CoveCli < Formula
  desc "Claude Code session manager — tmux-based multi-session workflow"
  homepage "https://github.com/rasha-hantash/cove"
  version "0.3.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rasha-hantash/cove/releases/download/v0.3.9/cove-cli-aarch64-apple-darwin.tar.xz"
      sha256 "365404899af32eaecc1edcc5117083d781aae6ef459d8ff7def78f825f740b05"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rasha-hantash/cove/releases/download/v0.3.9/cove-cli-x86_64-apple-darwin.tar.xz"
      sha256 "bc9bdc458ec11da34f5c63c2cf862198ef5670279a3d9b44664b7593e2f4cf4e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rasha-hantash/cove/releases/download/v0.3.9/cove-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3eb571feab85e38a4d13f1964a0174bee901096e55a16b3e3eb54557db7017db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rasha-hantash/cove/releases/download/v0.3.9/cove-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6d14b0bbe55f544b9829728cb915455d8c6167534b1d2cf9ebfd5d8771541311"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "cove" if OS.mac? && Hardware::CPU.arm?
    bin.install "cove" if OS.mac? && Hardware::CPU.intel?
    bin.install "cove" if OS.linux? && Hardware::CPU.arm?
    bin.install "cove" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
