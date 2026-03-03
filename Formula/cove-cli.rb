class CoveCli < Formula
  desc "Claude Code session manager — tmux-based multi-session workflow"
  homepage "https://github.com/rasha-hantash/cove"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rasha-hantash/cove/releases/download/v0.5.0/cove-cli-aarch64-apple-darwin.tar.xz"
      sha256 "9888c2b43cac9aa271b09cec897375dd660f49345f6306553d7a4c1e1a81f416"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rasha-hantash/cove/releases/download/v0.5.0/cove-cli-x86_64-apple-darwin.tar.xz"
      sha256 "fec59168c5276433ddc600ab6e8181de2d84eb3cdf878196d59cd3e83a707d09"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rasha-hantash/cove/releases/download/v0.5.0/cove-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a3478cecc47793cd931fc2789309896939b918e9c870479cf3f59bfa5e2b470b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rasha-hantash/cove/releases/download/v0.5.0/cove-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dbe46a16bacea3e5d5a38a300de5236dcab70bc334a43833805c7956e8be262b"
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
