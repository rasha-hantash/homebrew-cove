class CoveCli < Formula
  desc "Claude Code session manager — tmux-based multi-session workflow"
  homepage "https://github.com/rasha-hantash/cove"
  version "0.3.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rasha-hantash/cove/releases/download/v0.3.8/cove-cli-aarch64-apple-darwin.tar.xz"
      sha256 "4f914eb4ded7573a43908c80579b13e1e1e3937838bd85015a36d27832d1bfe5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rasha-hantash/cove/releases/download/v0.3.8/cove-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8152d5025c9f781909f450e9033c118eea66415465b8fc5e3cea7277d4a2b5aa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rasha-hantash/cove/releases/download/v0.3.8/cove-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6d057191419151fa91280bf4a1e97af854d326bdcb7103fde4659372e0bd1b78"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rasha-hantash/cove/releases/download/v0.3.8/cove-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6d91f67cfc0ae3b0d2a4f83dde4754a38c6f0afa91da6836fde1a53f7b14ede7"
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
