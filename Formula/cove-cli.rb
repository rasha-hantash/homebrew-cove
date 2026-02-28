class CoveCli < Formula
  desc "Claude Code session manager — tmux-based multi-session workflow"
  homepage "https://github.com/rasha-hantash/cove"
  version "0.3.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rasha-hantash/cove/releases/download/v0.3.3/cove-cli-aarch64-apple-darwin.tar.xz"
      sha256 "576cbca1f89648b058807af31b7bc33a7d379ee5c6c8d1d139c16c5052773b8f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rasha-hantash/cove/releases/download/v0.3.3/cove-cli-x86_64-apple-darwin.tar.xz"
      sha256 "9f4c300675a89b5a1785f0c31281c4b17659694572b6459c0011e65777ad9e33"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rasha-hantash/cove/releases/download/v0.3.3/cove-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d00e6cdd26d3a751b0830dccdf6904b6182a461276ee4096f33df4e13ddb39d3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rasha-hantash/cove/releases/download/v0.3.3/cove-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7b42b6882c87c0dae943b0d59ab28b48a9a0fad28a1d456b54b9b28163d394b6"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "cove"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "cove"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "cove"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "cove"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
