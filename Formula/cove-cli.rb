class CoveCli < Formula
  desc "Claude Code session manager — tmux-based multi-session workflow"
  homepage "https://github.com/rasha-hantash/cove"
  version "0.5.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rasha-hantash/cove/releases/download/v0.5.3/cove-cli-aarch64-apple-darwin.tar.xz"
      sha256 "7feff20d617dc6166437026cf70a37d8852bf80863bb83f18368921bf639a430"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rasha-hantash/cove/releases/download/v0.5.3/cove-cli-x86_64-apple-darwin.tar.xz"
      sha256 "3b1b87b1a399a64f8e433dcf6c9db965c1668c75e2c7a25afc3ee4752fbb6a95"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rasha-hantash/cove/releases/download/v0.5.3/cove-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d94abcd9e96eb27a40acf3a1c6807936f299413d6a6467480f0ead935f190444"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rasha-hantash/cove/releases/download/v0.5.3/cove-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "773bc5e6bb480a48bae090c7ec265aef835a49936039bc0907c4449757a272e0"
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
