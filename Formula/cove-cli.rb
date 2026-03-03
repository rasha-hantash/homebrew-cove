class CoveCli < Formula
  desc "Claude Code session manager — tmux-based multi-session workflow"
  homepage "https://github.com/rasha-hantash/cove"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rasha-hantash/cove/releases/download/v0.4.0/cove-cli-aarch64-apple-darwin.tar.xz"
      sha256 "c3fdbafda9630a4b491615221584d17c3d60fd5d13638418f03829045d49e854"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rasha-hantash/cove/releases/download/v0.4.0/cove-cli-x86_64-apple-darwin.tar.xz"
      sha256 "e1020d6dd77273a1ab618e824006aaadb5a013b5a0557e2cfe68ae304fc62302"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rasha-hantash/cove/releases/download/v0.4.0/cove-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "af90a1a998836cc2b2933d0f59732b6a08ee2fb0f2029e5a3a18736daa1c17f0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rasha-hantash/cove/releases/download/v0.4.0/cove-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8c26b2d8867b9e17800312cfccf541a8c02df34cdc9cdc5e35ba55a2df0e4729"
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
